package net.iperon.messenger

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaCodecList
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.Effect
import androidx.media3.effect.Crop
import androidx.media3.effect.FrameDropEffect
import androidx.media3.effect.Presentation
import androidx.media3.effect.ScaleAndRotateTransformation
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
 *  - `info` {path, thumb?, thumbSide, thumbAtMs?} → {width, height, durationMs,
 *    bitrate, fps} (размеры с учётом поворота) и кадр-превью JPEG (момент
 *    `thumbAtMs`, по умолчанию начало) в `thumb`;
 *  - `frames` {path, count, side, prefix} → пути JPEG `<prefix>_<i>.jpg` —
 *    кадры равномерно по длине видео (лента редактора; не вышло — пустая строка);
 *  - `compress` {id, path, out, shortSide, bitrate, codec, maxFps, startMs?,
 *    endMs?, mute?, crop?, rotation?} → путь к MP4 (`codec`: `hevc` | `h264`,
 *    + AAC) через Media3 Transformer (аппаратный кодек, кадры чаще `maxFps`
 *    прореживаются; `startMs`..`endMs` — обрезка, `endMs` 0 — до конца; `mute` —
 *    без звука; `crop` [left, top, width, height] долями показываемого кадра и
 *    `rotation` по часовой — кадрирование и поворот);
 *    прогресс — вызовом `progress` {id, progress} обратно в Dart. Нет
 *    аппаратного кодировщика — ошибка `unsupported` (Dart откатится на H.264);
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
                val thumbAtMs = call.argument<Number>("thumbAtMs")?.toLong() ?: 0L
                io.execute {
                    val info = try {
                        info(path, thumb, thumbSide, thumbAtMs)
                    } catch (e: Exception) {
                        Log.w(TAG, "info failed", e)
                        null
                    }
                    main.post { result.success(info) }
                }
            }
            "frames" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                val prefix = call.argument<String>("prefix") ?: return result.error("args", "prefix", null)
                val count = call.argument<Int>("count") ?: 10
                val side = call.argument<Int>("side") ?: 160
                io.execute {
                    val frames = try {
                        frames(path, count, side, prefix)
                    } catch (e: Exception) {
                        Log.w(TAG, "frames failed", e)
                        emptyList()
                    }
                    main.post { result.success(frames) }
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
    private fun info(path: String, thumb: String?, thumbSide: Int, thumbAtMs: Long): Map<String, Any>? {
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
                "fps" to frameRate(path),
            )
            if (thumb != null) {
                // Кадр уже повёрнут по метаданным. Обложка из редактора —
                // ровно выбранный кадр, иначе — ближайший ключевой (быстрее).
                val option = if (thumbAtMs > 0) MediaMetadataRetriever.OPTION_CLOSEST else MediaMetadataRetriever.OPTION_CLOSEST_SYNC
                retriever.getFrameAtTime(thumbAtMs * 1000, option)?.let { frame ->
                    FileOutputStream(thumb).use { scaled(frame, thumbSide).compress(Bitmap.CompressFormat.JPEG, 75, it) }
                    info["thumb"] = thumb
                }
            }
            return info
        } finally {
            retriever.release()
        }
    }

    private fun scaled(frame: Bitmap, side: Int): Bitmap {
        val scale = min(1f, side.toFloat() / max(frame.width, frame.height))
        if (scale >= 1f) return frame
        return Bitmap.createScaledBitmap(frame, (frame.width * scale).roundToInt(), (frame.height * scale).roundToInt(), true)
    }

    /** Кадры для ленты редактора: [count] штук по центрам равных отрезков. */
    private fun frames(path: String, count: Int, side: Int, prefix: String): List<String> {
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(path)
            val durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
            if (count <= 0 || durationMs <= 0) return emptyList()
            return (0 until count).map { i ->
                val us = durationMs * 1000 * (2 * i + 1) / (2 * count)
                // Для ленты точность не нужна: ближайший ключевой кадр в разы быстрее.
                val frame = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                    retriever.getScaledFrameAtTime(us, MediaMetadataRetriever.OPTION_CLOSEST_SYNC, side, side)
                } else {
                    retriever.getFrameAtTime(us, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)
                } ?: return@map ""
                val file = "${prefix}_$i.jpg"
                FileOutputStream(file).use { scaled(frame, side).compress(Bitmap.CompressFormat.JPEG, 70, it) }
                file
            }
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
        val maxFps = call.argument<Int>("maxFps") ?: 0
        val startMs = call.argument<Number>("startMs")?.toLong() ?: 0L
        val endMs = call.argument<Number>("endMs")?.toLong() ?: 0L
        val mute = call.argument<Boolean>("mute") ?: false
        val crop = call.argument<List<Number>>("crop")?.map { it.toFloat() }?.takeIf { it.size == 4 }
        val rotation = ((call.argument<Int>("rotation") ?: 0) % 360 + 360) % 360
        val videoMime = if (call.argument<String>("codec") == "hevc") MimeTypes.VIDEO_H265 else MimeTypes.VIDEO_H264
        // Программный HEVC-кодировщик есть почти везде, но он медленный и
        // слабый — HEVC только при аппаратном, иначе Dart возьмёт H.264.
        if (videoMime == MimeTypes.VIDEO_H265 && !hasHardwareEncoder(videoMime)) {
            return result.error("unsupported", videoMime, null)
        }
        File(out).delete()

        val encoders = DefaultEncoderFactory.Builder(context)
            .setRequestedVideoEncoderSettings(VideoEncoderSettings.Builder().setBitrate(bitrate).build())
            // Без тихой подмены кодека: при HEVC на низком битрейте H.264 вышел
            // бы заметно хуже — пусть лучше ошибка, и Dart повторит с H.264.
            .setEnableFallback(videoMime == MimeTypes.VIDEO_H264)
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
            .setVideoMimeType(videoMime)
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

        // Короткая сторона → shortSide (0 — без масштабирования, только
        // битрейт); чаще maxFps — прореживаем (реже — кадры не трогает).
        val reframe = if (crop != null || rotation != 0) reframeEffects(path, crop, rotation, shortSide) else null
        val videoEffects = buildList<Effect> {
            if (maxFps > 0) add(FrameDropEffect.createDefaultFrameDropEffect(maxFps.toFloat()))
            if (reframe != null) {
                addAll(reframe)
            } else if (shortSide > 0) {
                add(Presentation.createForShortSide(shortSide))
            }
        }
        val effects = Effects(listOf(), videoEffects)
        val clipping = MediaItem.ClippingConfiguration.Builder()
            .setStartPositionMs(startMs)
            .apply { if (endMs > 0) setEndPositionMs(endMs) }
            .build()
        val media = MediaItem.Builder().setUri(Uri.fromFile(File(path))).setClippingConfiguration(clipping).build()
        val item = EditedMediaItem.Builder(media).setEffects(effects).setRemoveAudio(mute).build()
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

    /**
     * Кадрирование [crop] (доли показываемого кадра) и поворот на [rotation] по
     * часовой; короткая сторона результата — не больше [shortSide] (0 — без
     * уменьшения). Эффекты Media3 работают с кадром уже в показываемой
     * ориентации; Crop — в NDC (-1..1, y вверх), поворот — против часовой.
     */
    private fun reframeEffects(path: String, crop: List<Float>?, rotation: Int, shortSide: Int): List<Effect> {
        val retriever = MediaMetadataRetriever()
        var width: Int
        var height: Int
        try {
            retriever.setDataSource(path)
            fun meta(key: Int) = retriever.extractMetadata(key)?.toIntOrNull() ?: 0
            width = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_WIDTH)
            height = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_HEIGHT)
            val sourceRotation = meta(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)
            if (sourceRotation == 90 || sourceRotation == 270) width = height.also { height = width }
        } finally {
            retriever.release()
        }
        val (left, top, w, h) = crop ?: listOf(0f, 0f, 1f, 1f)
        val cropW = max(1f, width * w)
        val cropH = max(1f, height * h)
        val scale = if (shortSide > 0) min(1f, shortSide / min(cropW, cropH)) else 1f
        // Кодеку нужны чётные стороны.
        fun even(v: Float) = max(2, (v * scale).roundToInt() and 1.inv())
        val quarter = rotation % 180 != 0
        val outW = if (quarter) even(cropH) else even(cropW)
        val outH = if (quarter) even(cropW) else even(cropH)
        return buildList {
            if (crop != null) add(Crop(-1 + 2 * left, -1 + 2 * (left + w), 1 - 2 * (top + h), 1 - 2 * top))
            if (rotation != 0) add(ScaleAndRotateTransformation.Builder().setRotationDegrees((360 - rotation).toFloat()).build())
            add(Presentation.createForWidthAndHeight(outW, outH, Presentation.LAYOUT_STRETCH_TO_FIT))
        }
    }

    /** Частота кадров видеодорожки из контейнера; 0 — неизвестно. */
    private fun frameRate(path: String): Double {
        val extractor = MediaExtractor()
        return try {
            extractor.setDataSource(path)
            (0 until extractor.trackCount).asSequence()
                .map { extractor.getTrackFormat(it) }
                .firstOrNull { it.getString(MediaFormat.KEY_MIME)?.startsWith("video/") == true }
                ?.takeIf { it.containsKey(MediaFormat.KEY_FRAME_RATE) }
                ?.let {
                    try {
                        it.getInteger(MediaFormat.KEY_FRAME_RATE).toDouble()
                    } catch (_: ClassCastException) {
                        it.getFloat(MediaFormat.KEY_FRAME_RATE).toDouble()
                    }
                } ?: 0.0
        } catch (e: Exception) {
            0.0
        } finally {
            extractor.release()
        }
    }

    private fun hasHardwareEncoder(mime: String): Boolean =
        MediaCodecList(MediaCodecList.REGULAR_CODECS).codecInfos.any { info ->
            info.isEncoder &&
                info.supportedTypes.any { it.equals(mime, ignoreCase = true) } &&
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    info.isHardwareAccelerated
                } else {
                    !info.name.startsWith("OMX.google.") && !info.name.startsWith("c2.android.")
                }
        }

    companion object {
        private const val TAG = "VideoCompressor"
        private const val CHANNEL = "net.iperon.messenger/video"
    }
}
