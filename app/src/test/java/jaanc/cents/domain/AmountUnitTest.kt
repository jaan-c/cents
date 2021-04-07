package jaanc.cents.domain

import org.junit.Assert.assertEquals
import org.junit.Test

class AmountUnitTest {
    @Test
    fun ofPositiveInt() {
        assertEquals(Amount.of(11), Amount.of("11"))
    }

    @Test
    fun ofNegativeInt() {
        assertEquals(Amount.of(-2), Amount.of("-2"))
    }

    @Test
    fun ofPositiveFloat() {
        assertEquals(Amount.of(12, 10), Amount.of("12.10"))
    }

    @Test
    fun ofNegativeFloat() {
        assertEquals(Amount.of(-11, 12), Amount.of("-11.12"))
    }
}