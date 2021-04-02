package jaanc.cents.widgets

import androidx.compose.foundation.layout.*
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
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
fun ExpenseListTile(expense: Expense) {
    val typography = MaterialTheme.typography
    val colors = MaterialTheme.colors

    Surface() {
        Column(modifier = Modifier.padding(16.dp)) {
            Text(
                expense.createdAt.displayRelative(), style = typography.overline
            )

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
                Text(
                    expense.note,
                    style = typography.subtitle2,
                    color = colors.onSurface.copy(alpha = 0.6f),
                    maxLines = 3,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}

@Preview
@Composable
fun ExpenseListTilePreview() {
    ExpenseListTile(
        Expense(
            category = ExpenseCategory("Food"),
            cost = Amount.from(12),
            note = "Cofe!"
        )
    )
}