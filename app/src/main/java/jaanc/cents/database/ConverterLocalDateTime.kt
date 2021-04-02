package jaanc.cents.database

import androidx.room.TypeConverter
import java.time.LocalDateTime

class ConverterLocalDateTime {
    @TypeConverter
    fun toTimestamp(dateTime: LocalDateTime): String {
        return dateTime.toString()
    }

    @TypeConverter
    fun fromTimestamp(timestamp: String): LocalDateTime {
        return LocalDateTime.parse(timestamp)
    }
}