package jaanc.cents.database

import androidx.room.TypeConverter
import jaanc.cents.domain.Amount

class ConverterAmount {
    @TypeConverter
    fun toTotalCents(amount: Amount): Int {
        return amount.totalCents
    }

    @TypeConverter
    fun fromTotalCents(totalCents: Int): Amount {
        return Amount(totalCents)
    }
}