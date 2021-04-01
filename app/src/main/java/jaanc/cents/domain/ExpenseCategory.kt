package jaanc.cents.domain

/**
 * A category for an [Expense].
 */
data class ExpenseCategory(val name: String) {
    companion object {
        fun uncategorized(): ExpenseCategory {
            return ExpenseCategory("")
        }
    }
}