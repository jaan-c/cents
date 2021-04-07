package jaanc.cents.domain

import kotlin.math.absoluteValue
import kotlin.math.roundToInt

/**
 * A monetary amount not tied to any currency.
 */
data class Amount(val totalCents: Int) {
    companion object {
        private const val CENT_PER_UNIT = 100

        fun zero(): Amount {
            return Amount(0)
        }

        fun of(unit: Int, cent: Int = 0): Amount {
            if (cent !in 0..99) {
                throw IllegalArgumentException("cent must be between 0..99, got $cent")
            }

            return Amount((unit * CENT_PER_UNIT) + cent)
        }

        fun of(amountText: String): Amount {
            val asDouble = amountText.toDoubleOrNull()
                ?: throw NumberFormatException("Invalid amount $amountText")

            val unit = asDouble.toInt()
            val cent = ((asDouble - unit) * 100).roundToInt().absoluteValue

            try {
                return of(unit, cent)
            } catch (_: IllegalArgumentException) {
                throw NumberFormatException("Invalid amount $amountText")
            }

        }
    }

    val unit: Int
        get() = totalCents / CENT_PER_UNIT

    val cent: Int
        get() = totalCents - (unit * CENT_PER_UNIT)
}