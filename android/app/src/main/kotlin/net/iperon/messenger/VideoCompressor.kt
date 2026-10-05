package net.iperon.messenger

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.effect.Presentation
import androidx.media3.transformer.Composition
import androidx.media3.transformer.DefaultEncoderFactory
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.Effects
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.ProgressHolder
import androidx.media3.transformer.Transformer
import androidx.media3.transformer.VideoEncoderSettings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.Executors
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt

/**
 * Сжатие видео для чата перед отправкой (сервер видит только шифротекст и
 * пережать сам не может — см. lib/chats/video_prepare.dart). Канал
 * `net.iperon.messenger/video`, тот же протокол, что у iOS (VideoCompressor.swift):
 *  - `info` {path, thumb?, thumbSide} → {width, height, durationMs, bitrate}
 *    (размеры с учётом поворота) и кадр-превью JPEG в `thumb`;
 *  - `compress` {id, path, out, shortSide, bitrate} → путь к MP4 (H.264 + AAC)
 *    через Media3 Transformer (аппаратный кодек); прогресс — вызовом
 *    `progress` {id, progress} обратно в Dart;
 *  - `cancel` {id}.
 */
class VideoCompressor(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, CHANNEL).also { it.setMethodCallHandler(this) }
    private val main = Handler(Looper.getMainLooper())
    private val io = Executors.newSingleThreadExecutor()

    /** Активные сжатия: Transformer работает только с потоком, где создан (main). */
    private val jobs = mutableMapOf<String, Transformer>()

    fun dispose() {
        channel.setMethodCallHandler(null)
        jobs.values.forEach { it.cancel() }
        jobs.clear()
        cancelCallbacks.clear()
        io.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "info" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                val thumb = call.argument<String>("thumb")
                val thumbSide = call.argument<Int>("thumbSide") ?: 320
                io.execute {
                    val info = try {
                        info(path, thumb, thumbSide)
                    } catch (e: Exception) {
                        Log.w(TAG, "info failed", e)
                        null
                    }
                    main.post { result.success(info) }
                }
            }
            "compress" -> compress(call, result)
            "cancel" -> {
                call.argument<String>("id")?.let { id ->
                    jobs.remove(id)?.cancel()
                    cancelCallbacks.remove(id)?.invoke()
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    /** Размеры (с поворотом), длительность, битрейт и кадр-превью. */
    private fun info(path: String, thumb: String?, thumbSide: Int): Map<String, Any>? {
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(path)
            fun meta(key: Int) = retriever.extractMetadata(key)?.toLongOrNull() ?: 0L
            var width = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH).toInt()
            var height = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT).toInt()
            if (width == 0 || height == 0) return null
            val rotation = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION).toInt()
            if (rotation == 90 || rotation == 270) width = height.also { height = width }
            val info = mutableMapOf<String, Any>(
                "width" to width,
                "height" to height,
                "durationMs" to meta(MediaMetadataRetriever.METADATA_KEY_DURATION),
                "bitrate" to meta(MediaMetadataRetriever.METADATA_KEY_BITRATE),
            )
            if (thumb != null) {
                // Кадр уже повёрнут по метаданным.
                retriever.getFrameAtTime(0, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)?.let { frame ->
                    val scale = min(1f, thumbSide.toFloat() / max(frame.width, frame.height))
                    val scaled = if (scale < 1f) {
                        Bitmap.createScaledBitmap(frame, (frame.width * scale).roundToInt(), (frame.height * scale).roundToInt(), true)
                    } else {
                        frame
                    }
                    FileOutputStream(thumb).use { scaled.compress(Bitmap.CompressFormat.JPEG, 75, it) }
                    info["thumb"] = thumb
                }
            }
            return info
        } finally {
            retriever.release()
        }
    }

    private fun compress(call: MethodCall, result: MethodChannel.Result) {
        val id = call.argument<String>("id") ?: return result.error("args", "id", null)
        val path = call.argument<String>("path") ?: return result.error("args", "path", null)
        val out = call.argument<String>("out") ?: return result.error("args", "out", null)
        val shortSide = call.argument<Int>("shortSide") ?: 0
        val bitrate = call.argument<Int>("bitrate") ?: 2_500_000
        File(out).delete()

        val encoders = DefaultEncoderFactory.Builder(context)
            .setRequestedVideoEncoderSettings(VideoEncoderSettings.Builder().setBitrate(bitrate).build())
            .build()
        var finished = false
        val progress = ProgressHolder()
        lateinit var transformer: Transformer
        // Прогресс Transformer не присылает сам — опрашиваем.
        val poll = object : Runnable {
            override fun run() {
                if (finished) return
                if (transformer.getProgress(progress) == Transformer.PROGRESS_STATE_AVAILABLE) {
                    channel.invokeMethod("progress", mapOf("id" to id, "progress" to progress.progress / 100.0))
                }
                main.postDelayed(this, 200)
            }
        }
        transformer = Transformer.Builder(context)
            .setVideoMimeType(MimeTypes.VIDEO_H264)
            .setAudioMimeType(MimeTypes.AUDIO_AAC)
            .setEncoderFactory(encoders)
            .addListener(object : Transformer.Listener {
                override fun onCompleted(composition: Composition, exportResult: ExportResult) {
                    finished = true
                    jobs.remove(id)
                    cancelCallbacks.remove(id)
                    result.success(out)
                }

                override fun onError(composition: Composition, exportResult: ExportResult, exportException: ExportException) {
                    finished = true
                    jobs.remove(id)
                    cancelCallbacks.remove(id)
                    File(out).delete()
                    Log.w(TAG, "compress failed", exportException)
                    result.error("compress", exportException.message, null)
                }
            })
            .build()

        // Короткая сторона → shortSide (0 — без масштабирования, только битрейт).
        val effects = if (shortSide > 0) Effects(listOf(), listOf(Presentation.createForShortSide(shortSide))) else Effects.EMPTY
        val item = EditedMediaItem.Builder(MediaItem.fromUri(Uri.fromFile(File(path)))).setEffects(effects).build()
        jobs[id] = transformer
        try {
            transformer.start(item, out)
        } catch (e: Exception) {
            finished = true
            jobs.remove(id)
            return result.error("compress", e.message, null)
        }
        main.post(poll)
        // Отмена: Transformer.cancel() не вызывает слушателя — отвечаем сами.
        cancelCallbacks[id] = {
            if (!finished) {
                finished = true
                File(out).delete()
                result.error("cancelled", null, null)
            }
        }
    }

    private val cancelCallbacks = mutableMapOf<String, () -> Unit>()

    companion object {
        private const val TAG = "VideoCompressor"
        private const val CHANNEL = "net.iperon.messenger/video"
    }
}
