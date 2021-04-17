package jaanc.cents.ui.expenselistpage

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import jaanc.cents.utils.display
import jaanc.cents.utils.displayRelative

@Composable
fun ExpenseListItem(expense: Expense, onClick: () -> Unit) {
    val typography = MaterialTheme.typography
    val colors = MaterialTheme.colors

    Surface(modifier = Modifier.clickable { onClick() }) {
        Column(modifier = Modifier.padding(16.dp)) {

            CompositionLocalProvider(LocalContentAlpha provides ContentAlpha.medium) {
                Text(
                    expense.createdAt.displayRelative(),
                    style = typography.overline,
                )
            }

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    if (expense.category.name.isNotBlank()) expense.category.name
                    else "Uncategorized",
                    style = typography.subtitle1,
                    modifier = Modifier.alignByBaseline()
                )
                Text(
                    expense.cost.display(),
                    style = typography.subtitle1,
                    modifier = Modifier.alignByBaseline()
                )
            }

            if (expense.note.isNotBlank()) {
                CompositionLocalProvider(LocalContentAlpha provides ContentAlpha.medium) {
                    Text(
                        expense.note,
                        style = typography.subtitle2,
                        maxLines = 3,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }
        }
    }
}

@Preview
@Composable
fun ExpenseListTilePreview() {
    ExpenseListItem(
        Expense(
            category = ExpenseCategory("Food"),
            cost = Amount.of(12),
            note = "Cofe!"
        )
    ) {}
}