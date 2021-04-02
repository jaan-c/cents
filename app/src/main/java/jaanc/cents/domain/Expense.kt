package jaanc.cents.domain

import java.time.LocalDateTime

data class Expense(
    val id: Int = UNSET_ID,
    val cost: Amount = Amount.zero(),
    val category: ExpenseCategory = ExpenseCategory.uncategorized(),
    val note: String = "",
    val createdAt: LocalDateTime = LocalDateTime.now(),
) {
    companion object {
        const val UNSET_ID = 0
    }
}