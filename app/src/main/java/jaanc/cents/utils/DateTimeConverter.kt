package jaanc.cents.utils

import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId

/// Converts this [LocalDate] to milliseconds since epoch without timezone
// offset.
/**
 * Converts [this] to milliseconds since epoch without timezone offset.
 */
fun LocalDate.toEpochMilli(): Long {
    return atStartOfDay(ZoneId.of("UTC")).toInstant().toEpochMilli()
}

/**
 * Treats [this] as milliseconds since epoch and converts it to [LocalDate]
 * without timezone offset.
 */
fun Long.toLocalDate(): LocalDate {
    return Instant.ofEpochMilli(this).atZone(ZoneId.of("UTC")).toLocalDate()
}