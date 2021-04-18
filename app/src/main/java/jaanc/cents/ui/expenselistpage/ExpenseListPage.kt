package jaanc.cents.ui.expenselistpage

import android.app.Application
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Add
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.navigate
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import java.time.LocalDateTime

@Composable
fun ExpenseListPage(navController: NavHostController) {
    val viewModel = viewModel<ExpenseListPageViewModel>(
        factory = ExpenseListPageViewModelFactory(LocalContext.current.applicationContext as Application)
    )

    val allExpenses by viewModel.allExpenses.observeAsState(listOf())

    ExpenseListPage(
        expenses = allExpenses,
        onOpenEditor = { expenseId ->
            navController.navigate("expense_editor_page?expenseId=$expenseId")
        },
        onOpenSettings = {},
        onOpenAbout = {},
    )
}

@Composable
fun ExpenseListPage(
    expenses: List<Expense>,
    onOpenEditor: (expenseId: Int) -> Unit,
    onOpenSettings: () -> Unit,
    onOpenAbout: () -> Unit,
) {
    Scaffold(
        topBar = { AppBar() },
        floatingActionButton = {
            AddExpenseFab(onAddExpense = { onOpenEditor(Expense.UNSET_ID) })
        },
        floatingActionButtonPosition = FabPosition.Center,
        isFloatingActionButtonDocked = true,
        bottomBar = { BottomBar(onOpenSettings, onOpenAbout) },
    ) {
        ExpenseList(expenses, onOpenEditor)
    }
}

@Composable
fun AppBar() {
    val colors = MaterialTheme.colors

    TopAppBar(
        contentColor = colors.onSurface,
        backgroundColor = colors.surface,
        elevation = 0.dp,
        title = { Text("Expenses") },
    )
}

@Composable
fun AddExpenseFab(onAddExpense: () -> Unit) {
    FloatingActionButton(onClick = { onAddExpense() }) {
        Icon(Icons.Rounded.Add, contentDescription = "Add Expense")
    }
}

@Composable
fun BottomBar(onOpenSettings: () -> Unit, onOpenAbout: () -> Unit) {
    BottomAppBar(cutoutShape = CircleShape) {
        Spacer(modifier = Modifier.weight(1f))
        OverflowMenuButton(onOpenSettings, onOpenAbout)
    }
}

@Composable
fun OverflowMenuButton(onOpenSettings: () -> Unit, onOpenAbout: () -> Unit) {
    var showDropdown by remember { mutableStateOf(false) }

    Box {
        IconButton(onClick = { showDropdown = true }) {
            Icon(Icons.Rounded.MoreVert, contentDescription = "More")
        }

        DropdownMenu(
            expanded = showDropdown,
            onDismissRequest = { showDropdown = false },
        ) {
            DropdownMenuItem(onClick = {
                onOpenSettings()
                showDropdown = false
            }) {
                Text("Settings")
            }
            DropdownMenuItem(onClick = {
                onOpenAbout()
                showDropdown = false
            }) {
                Text("About")
            }
        }
    }
}

@Preview
@Composable
fun ExpenseListPagePreview() {
    ExpenseListPage(
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
        ),
        onOpenEditor = {},
        onOpenSettings = {},
        onOpenAbout = {},
    )
}