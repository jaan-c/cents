package jaanc.cents.ui

import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.navArgument
import androidx.navigation.compose.rememberNavController
import jaanc.cents.domain.Expense
import jaanc.cents.ui.expenseeditorpage.ExpenseEditorPage
import jaanc.cents.ui.expenselistpage.ExpenseListPage
import jaanc.cents.ui.theme.CentsTheme

@Composable
fun Navigator() {
    val navController = rememberNavController()

    CentsTheme {
        NavHost(navController, startDestination = "expense_list_page") {
            composable("expense_list_page") { ExpenseListPage() }
            composable(
                "expense_editor_page?expenseId={expenseId}", arguments = listOf(
                    navArgument("expenseId") {
                        defaultValue = Expense.UNSET_ID
                        type = NavType.IntType
                    },
                )
            ) { backStackEntry ->
                ExpenseEditorPage(backStackEntry.arguments?.getInt("expense_id")!!)
            }
        }
    }
}