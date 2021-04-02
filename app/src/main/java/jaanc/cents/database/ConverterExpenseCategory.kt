package jaanc.cents.database

import androidx.room.TypeConverter
import jaanc.cents.domain.ExpenseCategory

class ConverterExpenseCategory {
    @TypeConverter
    fun toCategoryName(category: ExpenseCategory): String {
        return category.name
    }

    @TypeConverter
    fun fromCategoryName(name: String): ExpenseCategory {
        return ExpenseCategory(name)
    }
}