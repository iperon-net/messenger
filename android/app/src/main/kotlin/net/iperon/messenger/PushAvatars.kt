package net.iperon.messenger

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.BitmapShader
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.graphics.RectF
import android.graphics.Shader
import android.util.Log
import java.io.File
import java.util.concurrent.Executors

/// Аватары собеседников и групп для уведомлений (conversation-уведомления:
/// аватар вместо иконки приложения, иконка — маленьким значком в углу).
/// Нативный пуш-обработчик сам скачать их не может (файлы на CDN зашифрованы,
/// ключи — в SQLCipher-базе), поэтому приложение отдаёт уже скачанные аватары
/// ([sync], `syncAvatars` из Dart), а мы держим их уменьшенными копиями в
/// `filesDir/push_avatars`. Аналог PushAvatars.swift на iOS.
///
/// Ключи — `u<hex userID>` (личный чат, звонок, реакция) и `c<hex chatID>`
/// (группа). Снимок полный: новые и сменившиеся (другой cdnID) копируются,
/// пропавшие удаляются; что уже скопировано — помнят SharedPreferences
/// (ключ → cdnID).
object PushAvatars {
    private const val LOG_TAG = "IperonPush"
    private const val DIR = "push_avatars"
    private const val PREFS = "iperon_push_avatars"

    // Сторона квадрата копии в пикселях: в шторке аватар ~40dp.
    private const val SIDE = 192
    private val KEY = Regex("^[uc][0-9a-f]+$")
    private val executor = Executors.newSingleThreadExecutor()

    // Фон заглушки с инициалом, когда аватара нет (как в Telegram).
    private val PLACEHOLDER_COLORS = intArrayOf(
        0xFFE17076.toInt(), 0xFFF4A15C.toInt(), 0xFFA695E7.toInt(), 0xFF7BC862.toInt(),
        0xFF6EC9CB.toInt(), 0xFF65AADD.toInt(), 0xFFEE7AAE.toInt(),
    )

    /// Снимок аватаров из Dart: `[{key, id (hex cdnID), path}]`. В фоне —
    /// первый снимок может нести сотни картинок.
    fun sync(context: Context, entries: List<Map<String, String>>) {
        val app = context.applicationContext
        executor.execute { apply(app, entries) }
    }

    private fun apply(context: Context, entries: List<Map<String, String>>) {
        val dir = File(context.filesDir, DIR).apply { mkdirs() }
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        val editor = prefs.edit()
        val wanted = mutableSetOf<String>()
        for (entry in entries) {
            val key = entry["key"]?.takeIf { KEY.matches(it) } ?: continue
            val id = entry["id"] ?: continue
            val path = entry["path"] ?: continue
            wanted += key
            val target = File(dir, "$key.jpg")
            if (prefs.getString(key, null) == id && target.exists()) continue
            val bitmap = thumbnail(path) ?: continue
            try {
                val tmp = File(dir, "$key.tmp")
                tmp.outputStream().use { bitmap.compress(Bitmap.CompressFormat.JPEG, 85, it) }
                if (!tmp.renameTo(target)) {
                    tmp.delete()
                    continue
                }
                editor.putString(key, id)
            } catch (error: Exception) {
                Log.w(LOG_TAG, "push: avatar write failed", error)
            } finally {
                bitmap.recycle()
            }
        }
        for (key in prefs.all.keys) {
            if (key in wanted) continue
            File(dir, "$key.jpg").delete()
            editor.remove(key)
        }
        editor.apply()
    }

    /// Квадрат [SIDE]×[SIDE] по центру картинки (декодируем с прореживанием —
    /// исходник может быть крупным).
    private fun thumbnail(path: String): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null
        var sample = 1
        while (minOf(bounds.outWidth, bounds.outHeight) / (sample * 2) >= SIDE) sample *= 2
        val source = BitmapFactory.decodeFile(path, BitmapFactory.Options().apply { inSampleSize = sample }) ?: return null
        val side = minOf(source.width, source.height)
        val crop = Rect((source.width - side) / 2, (source.height - side) / 2, (source.width + side) / 2, (source.height + side) / 2)
        val result = Bitmap.createBitmap(SIDE, SIDE, Bitmap.Config.ARGB_8888)
        Canvas(result).drawBitmap(source, crop, Rect(0, 0, SIDE, SIDE), Paint(Paint.FILTER_BITMAP_FLAG))
        source.recycle()
        return result
    }

    fun user(context: Context, userID: ByteArray): Bitmap? = if (userID.isEmpty()) null else load(context, "u" + hex(userID))

    fun chat(context: Context, chatID: ByteArray): Bitmap? = if (chatID.isEmpty()) null else load(context, "c" + hex(chatID))

    /// Круглая копия (иконка Person / шорткат беседы / large icon).
    private fun load(context: Context, key: String): Bitmap? {
        val file = File(File(context.filesDir, DIR), "$key.jpg")
        if (!file.exists()) return null
        val square = BitmapFactory.decodeFile(file.path) ?: return null
        val result = Bitmap.createBitmap(square.width, square.height, Bitmap.Config.ARGB_8888)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply { shader = BitmapShader(square, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP) }
        Canvas(result).drawOval(RectF(0f, 0f, square.width.toFloat(), square.height.toFloat()), paint)
        square.recycle()
        return result
    }

    /// Заглушка: цветной круг с первой буквой [name]; цвет — по [seed]
    /// (userID / chatID), чтобы у одного собеседника он не менялся.
    fun placeholder(name: String, seed: ByteArray): Bitmap {
        val result = Bitmap.createBitmap(SIDE, SIDE, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(result)
        val color = PLACEHOLDER_COLORS[Math.floorMod(seed.contentHashCode(), PLACEHOLDER_COLORS.size)]
        canvas.drawOval(RectF(0f, 0f, SIDE.toFloat(), SIDE.toFloat()), Paint(Paint.ANTI_ALIAS_FLAG).apply { this.color = color })
        val letter = name.trim().let { if (it.isEmpty()) "" else String(Character.toChars(it.codePointAt(0))).uppercase() }
        if (letter.isNotEmpty()) {
            val text = Paint(Paint.ANTI_ALIAS_FLAG).apply {
                this.color = Color.WHITE
                textSize = SIDE * 0.45f
                textAlign = Paint.Align.CENTER
                isFakeBoldText = true
            }
            val y = SIDE / 2f - (text.descent() + text.ascent()) / 2
            canvas.drawText(letter, SIDE / 2f, y, text)
        }
        return result
    }

    /// Разлогин: копии больше не нужны.
    fun clear(context: Context) {
        executor.execute {
            File(context.applicationContext.filesDir, DIR).deleteRecursively()
            context.applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().clear().apply()
        }
    }

    private fun hex(bytes: ByteArray) = bytes.joinToString("") { "%02x".format(it) }
}
