package jaanc.cents.widgets

import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Add
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import java.time.LocalDateTime

@Composable
fun ExpenseListPage() {

}

@Composable
fun ExpenseListPage(expenses: List<Expense>) {
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Expenses") })
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { /*TODO*/ }) {
                Icon(Icons.Rounded.Add, contentDescription = "Add Expense")
            }
        },
    ) {
        ExpenseList(expenses)
    }
}

@Preview
@Composable
fun ExpenseListPagePreview() {
    ExpenseListPage(
        listOf(
            Expense(
                id = 1,
                category = ExpenseCategory("Food"),
                cost = Amount.from(12),
                note = "Cofe!"
            ),
            Expense(
                id = 2,
                category = ExpenseCategory("Commute"),
                cost = Amount.from(20),
                createdAt = LocalDateTime.now().minusDays(3)
            ),
            Expense(
                id = 3,
                category = ExpenseCategory("Internet"),
                cost = Amount.from(99),
                createdAt = LocalDateTime.now().minusDays(15)
            ),
        )
    )
}