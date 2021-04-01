package jaanc.cents.utils

import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.time.temporal.WeekFields

fun LocalTime.display12Hour(): String {
    val twelveHour = DateTimeFormatter.ofPattern("hh:mm a")

    return format(twelveHour)
}

fun LocalDate.display(): String {
    val full = DateTimeFormatter.ofPattern("MMM d, yyyy")

    return format(full)
}

fun LocalDate.displayRelative(from: LocalDate = LocalDate.now()): String {
    val thisWeek = DateTimeFormatter.ofPattern("EEE, MMM d")
    val thisMonth = DateTimeFormatter.ofPattern("MMM d")
    val thisYear = DateTimeFormatter.ofPattern("MMM d")
    val full = DateTimeFormatter.ofPattern("MMM d, yyyy")

    return if (this == from) {
        "Today"
    } else {
        format(
            when {
                weekOfYear == from.weekOfYear -> thisWeek
                month == from.month -> thisMonth
                year == from.year -> thisYear
                else -> full
            }
        )
    }
}

fun LocalDateTime.display(): String {
    val date = toLocalDate().display()
    val time = toLocalTime().display12Hour()

    return "$date, $time"
}

fun LocalDateTime.displayRelative(): String {
    val date = toLocalDate().displayRelative()
    val time = toLocalTime().display12Hour()

    return "$date, $time"
}

val LocalDate.weekOfYear: Int
    get() {
        return get(WeekFields.ISO.weekOfWeekBasedYear())
    }