package jaanc.cents.ui.expenselistpage

import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Add
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.compose.navigate
import androidx.navigation.compose.rememberNavController
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import java.time.LocalDateTime

@Composable
fun ExpenseListPage() {
    val viewModel = ExpenseListPageViewModel(LocalContext.current)
    val navController = rememberNavController()

    val allExpenses by viewModel.allExpenses.observeAsState(listOf())

    ExpenseListPage(
        expenses = allExpenses,
        onOpenEditor = { expenseId ->
            navController.navigate("expense_editor_page?expenseId=$expenseId")
        },
    )
}

@Composable
fun ExpenseListPage(
    expenses: List<Expense>, onOpenEditor: (expenseId: Int) -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Expenses") })
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { onOpenEditor(Expense.UNSET_ID) }) {
                Icon(Icons.Rounded.Add, contentDescription = "Add Expense")
            }
        },
    ) {
        ExpenseList(expenses, onOpenEditor)
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
        ),
    ) {}
}