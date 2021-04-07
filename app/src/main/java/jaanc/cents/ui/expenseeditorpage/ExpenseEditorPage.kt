package jaanc.cents.ui.expenseeditorpage

import android.app.Application
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material.icons.rounded.Check
import androidx.compose.material.icons.rounded.Schedule
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.vanpra.composematerialdialogs.MaterialDialog
import com.vanpra.composematerialdialogs.datetime.datetimepicker
import jaanc.cents.utils.displayRelative
import java.time.LocalDateTime


@Composable
fun ExpenseEditorPage(navController: NavHostController, expenseId: Int) {
    val viewModel = viewModel<ExpenseEditorPageViewModel>(
        factory = ExpenseEditorPageViewModelFactory(
            LocalContext.current.applicationContext as Application, expenseId
        )
    )

    val category by viewModel.categoryText.observeAsState("")
    val cost: String by viewModel.costText.observeAsState("")
    val note by viewModel.noteText.observeAsState("")
    val createdAt by viewModel.createdAt.observeAsState(LocalDateTime.now())
    val canSave by viewModel.canSave.observeAsState(false)
    val shouldNavigateUp by viewModel.shouldNavigateUp.observeAsState(false)

    if (shouldNavigateUp) {
        navController.popBackStack()
        viewModel.doneNavigatingUp()
    }

    ExpenseEditorPage(
        category = category,
        cost = cost,
        note = note,
        createdAt = createdAt,
        setCategory = viewModel::setCategoryText,
        setCost = viewModel::setCostText,
        setNote = viewModel::setNoteText,
        setCreatedAt = viewModel::setCreatedAt,
        onNavigateUp = { navController.popBackStack() },
        canSave = canSave,
        onSaveExpense = viewModel::saveExpense,
    )
}

@Composable
fun ExpenseEditorPage(
    category: String,
    cost: String,
    note: String,
    createdAt: LocalDateTime,
    setCategory: (String) -> Unit,
    setCost: (String) -> Unit,
    setNote: (String) -> Unit,
    setCreatedAt: (LocalDateTime) -> Unit,
    onNavigateUp: () -> Unit,
    canSave: Boolean,
    onSaveExpense: () -> Unit,
) {
    val dialog = remember { MaterialDialog() }

    Scaffold(
        topBar = { AppBar(onNavigateUp) },
        floatingActionButton = {
            if (canSave) {
                SaveExpenseFab(onSaveExpense)
            }
        },
        floatingActionButtonPosition = FabPosition.End,
    ) {
        Column(
            modifier = Modifier.padding(vertical = 4.dp, horizontal = 8.dp)
        ) {
            Row {
                CategoryField(
                    category, setCategory, modifier = Modifier.weight(1f)
                )
                CostField(
                    cost,
                    setCost,
                    modifier = Modifier
                        .width(100.dp)
                        .padding(start = 8.dp),
                )
            }

            NoteField(
                note,
                setNote,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 4.dp),
            )

            CreationDateTimePicker(
                createdAt,
                onOpenPicker = { dialog.show() },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
            )
        }

        dialog.build {
            datetimepicker(createdAt, onComplete = setCreatedAt)
        }
    }
}

@Composable
private fun AppBar(onNavigateUp: () -> Unit) {
    val colors = MaterialTheme.colors

    TopAppBar(
        contentColor = colors.onSurface,
        backgroundColor = colors.surface,
        navigationIcon = {
            IconButton(onClick = onNavigateUp) {
                Icon(Icons.Rounded.ArrowBack, contentDescription = "Back")
            }
        },
        title = { Text("Add Expense") },
    )
}

@Composable
fun SaveExpenseFab(onSaveExpense: () -> Unit) {
    FloatingActionButton(onClick = onSaveExpense) {
        Icon(Icons.Rounded.Check, contentDescription = "Save Expense")
    }
}

@Composable
private fun CategoryField(
    category: String,
    setCategory: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        category,
        setCategory,
        modifier = modifier,
        singleLine = true,
        keyboardOptions = KeyboardOptions(
            capitalization = KeyboardCapitalization.Words, autoCorrect = true
        ),
        label = { Text("Category") },
        placeholder = { Text("Uncategorized") },
    )
}

@Composable
private fun CostField(
    cost: String, setCost: (String) -> Unit, modifier: Modifier = Modifier
) {
    OutlinedTextField(
        cost,
        setCost,
        modifier = modifier,
        singleLine = true,
        textStyle = LocalTextStyle.current.copy(textAlign = TextAlign.End),
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
        label = { Text("Cost") },
        // FIXME: textAlign does not work!
        placeholder = { Text("0.00", textAlign = TextAlign.End) },
    )
}

@Composable
private fun NoteField(
    note: String, setNote: (String) -> Unit, modifier: Modifier = Modifier
) {
    OutlinedTextField(
        note,
        setNote,
        modifier = modifier.requiredHeight(120.dp),
        maxLines = 3,
        keyboardOptions = KeyboardOptions(
            capitalization = KeyboardCapitalization.Words, autoCorrect = true
        ),
        label = { Text("Note") },
    )
}

@Composable
private fun CreationDateTimePicker(
    dateTime: LocalDateTime,
    onOpenPicker: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Box(modifier = modifier) {
        OutlinedTextField(
            dateTime.displayRelative(),
            {},
            modifier = Modifier.fillMaxWidth(),
            readOnly = true,
            singleLine = true,
            label = { Text("Creation Time") },
            leadingIcon = {
                Icon(
                    Icons.Rounded.Schedule, contentDescription = "Creation Time"
                )
            },
        )

        Box(
            modifier = Modifier
                .matchParentSize()
                .clickable { onOpenPicker() },
        )
    }
}

@Preview
@Composable
fun ExpenseEditorPagePreview() {
    var category by remember { mutableStateOf("") }
    var cost by remember { mutableStateOf("") }
    var note by remember { mutableStateOf("") }
    var createdAt by remember { mutableStateOf(LocalDateTime.now()) }

    ExpenseEditorPage(
        category = category,
        cost = cost,
        note = note,
        createdAt = createdAt,
        setCategory = { category = it },
        setCost = { cost = it },
        setNote = { note = it },
        setCreatedAt = { createdAt = it },
        onNavigateUp = {},
        canSave = true,
        onSaveExpense = {},
    )
}