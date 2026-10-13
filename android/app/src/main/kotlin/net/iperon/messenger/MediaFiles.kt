package net.iperon.messenger

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.ClipboardManager
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/** FileProvider приложения (свой класс — у плагинов свои FileProvider, и с общим
 *  `androidx.core.content.FileProvider` манифесты конфликтуют при слиянии). */
class MediaFileProvider : FileProvider()

/**
 * Файлы и медиа чата для системы (см. lib/chats/media_files.dart). Канал
 * `net.iperon.messenger/files`:
 *  - `open` {path} → приложение для этого типа (ACTION_VIEW); `false` — такого нет;
 *  - `copy` {paths} → в буфер обмена ссылками content:// (фото и видео вставляются
 *    в другие приложения: доступ к ссылке система выдаёт тому, кто вставляет);
 *  - `saveToGallery` {path, video} → Pictures/Iperon или Movies/Iperon;
 *  - `saveFile` {path} → Download/Iperon;
 *  - `clipboardHasMedia` → есть ли в буфере обмена фото / видео (по описанию —
 *    без чтения, Android не показывает «вставлено из буфера»);
 *  - `pasteMedia` {dir} → фото / видео из буфера обмена (ссылки content://, например
 *    «Копировать» в галерее) файлами в `dir` → [{path, video}].
 * Буфер обмена сменился — вызов `clipboardChanged` в Dart.
 * До Android 10 сохранение пишет в общую папку — нужно WRITE_EXTERNAL_STORAGE:
 * нет его — ошибка `permission` (Dart попросит и повторит).
 */
class MediaFiles(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, CHANNEL).also { it.setMethodCallHandler(this) }
    private val main = Handler(Looper.getMainLooper())
    private val io = Executors.newSingleThreadExecutor()
    private val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    private val clipboardListener = ClipboardManager.OnPrimaryClipChangedListener {
        channel.invokeMethod("clipboardChanged", null)
    }

    init {
        clipboard.addPrimaryClipChangedListener(clipboardListener)
    }

    fun dispose() {
        clipboard.removePrimaryClipChangedListener(clipboardListener)
        channel.setMethodCallHandler(null)
        io.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "open" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                result.success(open(File(path)))
            }
            "copy" -> {
                val paths = call.argument<List<String>>("paths").orEmpty()
                if (paths.isEmpty()) return result.error("args", "paths", null)
                copy(paths.map(::File), result)
            }
            "saveToGallery" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                val video = call.argument<Boolean>("video") ?: false
                save(File(path), if (video) Target.MOVIES else Target.PICTURES, result)
            }
            "saveFile" -> {
                val path = call.argument<String>("path") ?: return result.error("args", "path", null)
                save(File(path), Target.DOWNLOADS, result)
            }
            "clipboardHasMedia" -> result.success(clipboardHasMedia())
            "pasteMedia" -> {
                val dir = call.argument<String>("dir") ?: return result.error("args", "dir", null)
                pasteMedia(File(dir), result)
            }
            else -> result.notImplemented()
        }
    }

    private fun uriOf(file: File): Uri = FileProvider.getUriForFile(context, "${context.packageName}.files", file)

    private fun open(file: File): Boolean {
        val intent = Intent(Intent.ACTION_VIEW)
            .setDataAndType(uriOf(file), mimeOf(file))
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        if (context !is Activity) intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return try {
            context.startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }

    private fun copy(files: List<File>, result: MethodChannel.Result) {
        try {
            val resolver = context.contentResolver
            val uris = files.filter { it.exists() }.map(::uriOf)
            if (uris.isEmpty()) return result.error("failed", "no readable files", null)
            val clip = ClipData.newUri(resolver, "Iperon", uris.first())
            uris.drop(1).forEach { clip.addItem(ClipData.Item(it)) }
            clipboard.setPrimaryClip(clip)
            result.success(null)
        } catch (e: Exception) {
            result.error("failed", e.message, null)
        }
    }

    private fun clipboardHasMedia(): Boolean {
        val description = clipboard.primaryClipDescription ?: return false
        return description.hasMimeType("image/*") || description.hasMimeType("video/*")
    }

    private fun pasteMedia(dir: File, result: MethodChannel.Result) {
        val clip = clipboard.primaryClip ?: return result.success(emptyList<Map<String, Any>>())
        val resolver = context.contentResolver
        val uris = (0 until clip.itemCount).mapNotNull { clip.getItemAt(it).uri }
        io.execute {
            val pasted = mutableListOf<Map<String, Any>>()
            dir.mkdirs()
            val stamp = System.currentTimeMillis()
            uris.forEachIndexed { i, uri ->
                try {
                    val mime = resolver.getType(uri) ?: return@forEachIndexed
                    val video = mime.startsWith("video/")
                    if (!video && !mime.startsWith("image/")) return@forEachIndexed
                    val ext = MimeTypeMap.getSingleton().getExtensionFromMimeType(mime) ?: if (video) "mp4" else "jpg"
                    val out = File(dir, "paste_${stamp}_$i.$ext")
                    resolver.openInputStream(uri)?.use { input -> out.outputStream().use { input.copyTo(it) } } ?: return@forEachIndexed
                    pasted.add(mapOf("path" to out.absolutePath, "video" to video))
                } catch (_: Exception) {
                    // Нет доступа к ссылке / файл пропал — пропускаем.
                }
            }
            main.post { result.success(pasted) }
        }
    }

    private enum class Target(val directory: String) {
        PICTURES(Environment.DIRECTORY_PICTURES),
        MOVIES(Environment.DIRECTORY_MOVIES),
        DOWNLOADS(Environment.DIRECTORY_DOWNLOADS),
    }

    private fun save(file: File, target: Target, result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q &&
            ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
        ) {
            return result.error("permission", null, null)
        }
        io.execute {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) saveToMediaStore(file, target) else saveLegacy(file, target)
                main.post { result.success(null) }
            } catch (e: Exception) {
                main.post { result.error("failed", e.message, null) }
            }
        }
    }

    /** Android 10+: через MediaStore, без разрешений. */
    private fun saveToMediaStore(file: File, target: Target) {
        val collection = when (target) {
            Target.PICTURES -> MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            Target.MOVIES -> MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
            Target.DOWNLOADS -> MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        }
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeOf(file))
            put(MediaStore.MediaColumns.RELATIVE_PATH, "${target.directory}/$FOLDER")
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }
        val resolver = context.contentResolver
        val uri = resolver.insert(collection, values) ?: error("insert failed")
        try {
            resolver.openOutputStream(uri)?.use { out -> file.inputStream().use { it.copyTo(out) } } ?: error("open failed")
            resolver.update(uri, ContentValues().apply { put(MediaStore.MediaColumns.IS_PENDING, 0) }, null, null)
        } catch (e: Exception) {
            resolver.delete(uri, null, null)
            throw e
        }
    }

    /** До Android 10: в общую папку и в индекс медиа. */
    @Suppress("DEPRECATION")
    private fun saveLegacy(file: File, target: Target) {
        val dir = File(Environment.getExternalStoragePublicDirectory(target.directory), FOLDER).apply { mkdirs() }
        var out = File(dir, file.name)
        var n = 1
        while (out.exists()) {
            out = File(dir, "${file.nameWithoutExtension} ($n)${if (file.extension.isEmpty()) "" else ".${file.extension}"}")
            n++
        }
        file.copyTo(out)
        MediaScannerConnection.scanFile(context, arrayOf(out.absolutePath), arrayOf(mimeOf(file)), null)
    }

    private fun mimeOf(file: File): String =
        MimeTypeMap.getSingleton().getMimeTypeFromExtension(file.extension.lowercase()) ?: "application/octet-stream"

    companion object {
        const val CHANNEL = "net.iperon.messenger/files"
        private const val FOLDER = "Iperon"
    }
}
