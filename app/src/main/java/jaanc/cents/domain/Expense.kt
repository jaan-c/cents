package jaanc.cents.domain

import java.time.LocalDateTime

data class Expense(
    val id: Int = 0,
    val cost: Amount = Amount.zero(),
    val category: ExpenseCategory = ExpenseCategory.uncategorized(),
    val note: String = "",
    val createdAt: LocalDateTime = LocalDateTime.now(),
)