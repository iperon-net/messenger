package com.hiennv.flutter_callkit_incoming.widgets

import android.graphics.*
import coil.size.Size
import coil.transform.Transformation
import kotlin.math.min


// [iperon fork] API Coil 2 (Transformation без BitmapPool, key() → cacheKey):
// VK ID SDK (third_party/vkid_flutter_sdk) тянет coil 2.6.0, и он вытесняет coil
// 1.4 из classpath приложения — со старой сигнатурой R8 падал на отсутствующем
// coil.bitmap.BitmapPool.
class CircleTransform : Transformation {

    override val cacheKey: String = "circle"

    override suspend fun transform(input: Bitmap, size: Size): Bitmap {
        val sizeImage = min(input.width, input.height)
        val x = (input.width - sizeImage) / 2
        val y = (input.height - sizeImage) / 2
        val squaredBitmap = Bitmap.createBitmap(input, x, y, sizeImage, sizeImage)
        if (squaredBitmap != input) {
            input.recycle()
        }
        val config = input.config ?: Bitmap.Config.ARGB_8888
        val bitmap = Bitmap.createBitmap(sizeImage, sizeImage, config)
        val canvas = Canvas(bitmap)
        val paint = Paint()
        val shader = BitmapShader(
            squaredBitmap,
            Shader.TileMode.CLAMP, Shader.TileMode.CLAMP
        )
        paint.shader = shader
        paint.isAntiAlias = true
        val r = sizeImage / 2f
        canvas.drawCircle(r, r, r, paint)
        squaredBitmap.recycle()
        return bitmap
    }
}
