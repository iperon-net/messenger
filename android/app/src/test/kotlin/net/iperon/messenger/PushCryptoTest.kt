package net.iperon.messenger

import org.json.JSONObject
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import java.io.File

/// Расшифровка и разбор пушей на общих тест-векторах сервера
/// (internal/crypto/testdata/push_vectors.json, копия в test/fixtures/).
class PushCryptoTest {
    private val vectors = JSONObject(File("../../test/fixtures/push_vectors.json").readText()).getJSONArray("vectors")

    private fun hex(value: String) = ByteArray(value.length / 2) { value.substring(it * 2, it * 2 + 2).toInt(16).toByte() }

    @Test
    fun decryptsAllVectors() {
        for (i in 0 until vectors.length()) {
            val vector = vectors.getJSONObject(i)
            val session = hex(vector.getString("session"))
            val opened = PushCrypto.open(vector.getString("p")) { keyId ->
                assertArrayEquals(session.copyOfRange(0, PushCrypto.KEY_ID_LENGTH), keyId)
                hex(vector.getString("pushKey"))
            }
            assertArrayEquals("vector #$i", hex(vector.getString("plaintext")), opened)
        }
    }

    @Test
    fun parsesPushPayloadVector() {
        for (i in 0 until vectors.length()) {
            val vector = vectors.getJSONObject(i)
            val expected = vector.optJSONObject("payload") ?: continue

            val payload = PushPayload.parse(hex(vector.getString("plaintext")))

            assertEquals(expected.getInt("kind"), payload.kind)
            assertEquals(expected.getString("id"), payload.id)
            assertArrayEquals(hex(expected.getString("fromUserID")), payload.fromUserID)
            assertArrayEquals(hex(expected.getString("chatID")), payload.chatID)
            assertEquals(expected.getLong("messageID"), payload.messageID)
            assertEquals(expected.getString("title"), payload.title)
            assertEquals(expected.getString("body"), payload.body)
            assertEquals(listOf("a", "b"), payload.args)
            assertEquals(expected.getInt("badge"), payload.badge)
            assertEquals(expected.getLong("date"), payload.date)
            assertEquals(listOf(5L, 6L), payload.messageIDs)
        }
    }

    @Test
    fun missingKeyReturnsNull() {
        val vector = vectors.getJSONObject(0)
        assertNull(PushCrypto.open(vector.getString("p")) { null })
    }

    @Test(expected = PushCrypto.MalformedPayloadException::class)
    fun wrongKeyThrows() {
        val vector = vectors.getJSONObject(0)
        PushCrypto.open(vector.getString("p")) { ByteArray(32) }
    }

    @Test
    fun skipsUnknownFields() {
        // поле 99 (varint) + поле 2 "x"
        val bytes = byteArrayOf(0x98.toByte(), 0x06, 0x01, 0x12, 0x01, 'x'.code.toByte())
        assertEquals("x", PushPayload.parse(bytes).id)
    }
}
