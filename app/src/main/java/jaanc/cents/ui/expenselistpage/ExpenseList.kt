package jaanc.cents.ui.expenselistpage

import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.Divider
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import java.time.LocalDateTime

@Composable
fun ExpenseList(expenses: List<Expense>) {
    LazyColumn() {
        items(items = expenses, key = Expense::id) { e ->
            ExpenseListTile(e)
            if (e != expenses.last()) {
                Divider()
            }
        }
    }
}

@Preview
@Composable
fun ExpenseListPreview() {
    ExpenseList(
        expenses = listOf(
            Expense(
                id = 1,
                category = ExpenseCategory("Food"),
                cost = Amount.of(12),
                note = "Cofe!"
            ),
            Expense(
                id = 2,
                category = ExpenseCategory("Commute"),
                cost = Amount.of(20),
                createdAt = LocalDateTime.now().minusDays(3)
            ),
            Expense(
                id = 3,
                category = ExpenseCategory("Internet"),
                cost = Amount.of(99),
                createdAt = LocalDateTime.now().minusDays(15)
            ),
        )
    )
}