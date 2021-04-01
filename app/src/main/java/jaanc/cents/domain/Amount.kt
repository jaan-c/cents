package jaanc.cents.domain

/**
 * A monetary amount not tied to any currency.
 */
data class Amount(val totalCents: Int) {
    companion object {
        private const val CENT_PER_UNIT = 100

        fun zero(): Amount {
            return Amount(0)
        }

        fun from(unit: Int, cent: Int = 0): Amount {
            if (cent !in 0..99) {
                throw IllegalArgumentException("cent must be between 0..99")
            }

            return Amount((unit * CENT_PER_UNIT) + cent)
        }
    }

    val unit: Int
        get() = totalCents / CENT_PER_UNIT

    val cent: Int
        get() = totalCents - (unit * CENT_PER_UNIT)
}