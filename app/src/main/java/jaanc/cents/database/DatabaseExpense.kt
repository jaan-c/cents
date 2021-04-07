package jaanc.cents.database

import androidx.room.Entity
import androidx.room.PrimaryKey
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import java.time.LocalDateTime

@Entity(tableName = "Expenses")
data class DatabaseExpense(
    @PrimaryKey(autoGenerate = true) val id: Int,
    val cost: Amount,
    val category: ExpenseCategory,
    val note: String,
    val createdAt: LocalDateTime,
) {
    companion object {
        fun of(expense: Expense): DatabaseExpense {
            return DatabaseExpense(
                expense.id,
                expense.cost,
                expense.category,
                expense.note,
                expense.createdAt
            )
        }
    }

    fun asDomain(): Expense {
        return Expense(id, category, cost, note, createdAt)
    }
}