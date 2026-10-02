package net.iperon.messenger

/// Разобранный `PushPayload` (protos/push_payload_v1.proto). Свой минимальный
/// декодер protobuf вместо protobuf-javalite + codegen: сообщение одно, плоское и
/// маленькое. Неизвестные поля пропускаются (совместимость с новыми версиями
/// сервера). Номера полей должны совпадать с proto.
data class PushPayload(
    val kind: Int = KIND_UNKNOWN,
    val id: String = "",
    val fromUserID: ByteArray = ByteArray(0),
    val chatID: ByteArray = ByteArray(0),
    val messageID: Long = 0,
    val title: String = "",
    val body: String = "",
    val args: List<String> = emptyList(),
    val badge: Int = 0,
    val date: Long = 0,
    val messageIDs: List<Long> = emptyList(),
) {
    companion object {
        // PushPayload.Kind
        const val KIND_UNKNOWN = 0
        const val KIND_TEST = 1
        const val KIND_CONTACT_JOINED = 2
        const val KIND_CALL_MISSED = 3
        const val KIND_MESSAGE = 10
        const val KIND_READ_HISTORY = 11
        const val KIND_MESSAGE_DELETED = 12

        private const val WIRE_VARINT = 0
        private const val WIRE_FIXED64 = 1
        private const val WIRE_LENGTH = 2
        private const val WIRE_FIXED32 = 5

        class MalformedProtoException(message: String) : Exception(message)

        fun parse(bytes: ByteArray): PushPayload {
            val reader = Reader(bytes)
            var payload = PushPayload()
            val args = mutableListOf<String>()
            val messageIDs = mutableListOf<Long>()

            while (!reader.atEnd()) {
                val tag = reader.varint()
                val field = (tag ushr 3).toInt()
                val wire = (tag and 7).toInt()

                payload = when (field) {
                    1 -> payload.copy(kind = reader.expectVarint(wire).toInt())
                    2 -> payload.copy(id = reader.expectString(wire))
                    3 -> payload.copy(fromUserID = reader.expectBytes(wire))
                    4 -> payload.copy(chatID = reader.expectBytes(wire))
                    5 -> payload.copy(messageID = reader.expectVarint(wire))
                    6 -> payload.copy(title = reader.expectString(wire))
                    7 -> payload.copy(body = reader.expectString(wire))
                    8 -> { args += reader.expectString(wire); payload }
                    9 -> payload.copy(badge = reader.expectVarint(wire).toInt())
                    10 -> payload.copy(date = reader.expectVarint(wire))
                    11 -> {
                        // repeated int64: proto3 пишет packed, но парсер обязан
                        // принимать и unpacked.
                        if (wire == WIRE_LENGTH) {
                            val packed = Reader(reader.bytes())
                            while (!packed.atEnd()) messageIDs += packed.varint()
                        } else {
                            messageIDs += reader.expectVarint(wire)
                        }
                        payload
                    }
                    else -> { reader.skip(wire); payload }
                }
            }

            return payload.copy(args = args, messageIDs = messageIDs)
        }

        private class Reader(private val data: ByteArray) {
            private var position = 0

            fun atEnd() = position >= data.size

            fun varint(): Long {
                var result = 0L
                var shift = 0
                while (shift < 64) {
                    if (atEnd()) throw MalformedProtoException("truncated varint")
                    val byte = data[position++].toInt()
                    result = result or ((byte and 0x7F).toLong() shl shift)
                    if (byte and 0x80 == 0) return result
                    shift += 7
                }
                throw MalformedProtoException("varint too long")
            }

            fun bytes(): ByteArray {
                val length = varint()
                if (length < 0 || length > data.size - position) throw MalformedProtoException("truncated bytes")
                val end = position + length.toInt()
                return data.copyOfRange(position, end).also { position = end }
            }

            fun expectVarint(wire: Int): Long {
                if (wire != WIRE_VARINT) throw MalformedProtoException("expected varint, got wire $wire")
                return varint()
            }

            fun expectBytes(wire: Int): ByteArray {
                if (wire != WIRE_LENGTH) throw MalformedProtoException("expected length-delimited, got wire $wire")
                return bytes()
            }

            fun expectString(wire: Int): String = String(expectBytes(wire), Charsets.UTF_8)

            fun skip(wire: Int) {
                when (wire) {
                    WIRE_VARINT -> varint()
                    WIRE_LENGTH -> bytes()
                    WIRE_FIXED64 -> advance(8)
                    WIRE_FIXED32 -> advance(4)
                    else -> throw MalformedProtoException("unsupported wire type $wire")
                }
            }

            private fun advance(count: Int) {
                if (count > data.size - position) throw MalformedProtoException("truncated fixed")
                position += count
            }
        }
    }

    // data class с массивами: equals/hashCode по содержимому (для тестов).
    override fun equals(other: Any?): Boolean =
        other is PushPayload && kind == other.kind && id == other.id &&
            fromUserID.contentEquals(other.fromUserID) && chatID.contentEquals(other.chatID) &&
            messageID == other.messageID && title == other.title && body == other.body &&
            args == other.args && badge == other.badge && date == other.date && messageIDs == other.messageIDs

    override fun hashCode(): Int = id.hashCode() * 31 + kind
}
