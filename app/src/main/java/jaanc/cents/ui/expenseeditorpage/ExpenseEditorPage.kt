package jaanc.cents.ui.expenseeditorpage

import android.app.Application
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.DialogProperties
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.google.android.material.datepicker.MaterialDatePicker
import com.google.android.material.timepicker.MaterialTimePicker
import com.google.android.material.timepicker.TimeFormat
import jaanc.cents.ui.widgets.ButtonBar
import jaanc.cents.utils.display
import jaanc.cents.utils.display12Hour
import jaanc.cents.utils.toEpochMilli
import jaanc.cents.utils.toLocalDate
import java.time.LocalDate
import java.time.LocalTime


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
    val canSave by viewModel.canSave.observeAsState(false)
    val creationDate by viewModel.creationDate.observeAsState(LocalDate.now())
    val creationTime by viewModel.creationTime.observeAsState(LocalTime.now())
    val categories by viewModel.categories.observeAsState(listOf())
    val shouldShowDatePicker by viewModel.shouldShowDatePicker.observeAsState(
        false
    )
    val shouldShowTimePicker by viewModel.shouldShowTimePicker.observeAsState(
        false
    )
    val shouldNavigateUp by viewModel.shouldNavigateUp.observeAsState(false)

    if (shouldNavigateUp) {
        if (navController.popBackStack()) {
            viewModel.doneNavigatingUp()
        }
    }

    if (shouldShowDatePicker) {
        val activity = LocalContext.current as FragmentActivity
        val fragmentManager = activity.supportFragmentManager

        showDatePicker(
            fragmentManager,
            creationDate,
            viewModel::setCreationDate,
        )
        viewModel.doneShowingDatePicker()
    }

    if (shouldShowTimePicker) {
        val activity = LocalContext.current as FragmentActivity
        val fragmentManager = activity.supportFragmentManager

        showTimePicker(
            fragmentManager,
            creationTime,
            viewModel::setCreationTime,
        )
        viewModel.doneShowingTimePicker()
    }

    ExpenseEditorPage(
        category = category,
        cost = cost,
        note = note,
        creationDate = creationDate,
        creationTime = creationTime,
        categories = categories,
        setCategory = viewModel::setCategoryText,
        setCost = viewModel::setCostText,
        setNote = viewModel::setNoteText,
        onEditCreationDate = viewModel::showDatePicker,
        onEditCreationTime = viewModel::showTimePicker,
        onNavigateUp = viewModel::navigateUp,
        canSave = canSave,
        onSaveExpense = viewModel::saveExpense,
    )
}

@Composable
fun ExpenseEditorPage(
    category: String,
    cost: String,
    note: String,
    creationDate: LocalDate,
    creationTime: LocalTime,
    categories: List<String>,
    setCategory: (String) -> Unit,
    setCost: (String) -> Unit,
    setNote: (String) -> Unit,
    onEditCreationDate: () -> Unit,
    onEditCreationTime: () -> Unit,
    onNavigateUp: () -> Unit,
    canSave: Boolean,
    onSaveExpense: () -> Unit,
) {
    var shouldShowCategoryPicker by remember { mutableStateOf(false) }

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
                    category,
                    setCategory,
                    onShowCategoryPicker = if (categories.isNotEmpty()) {
                        { shouldShowCategoryPicker = true }
                    } else null,
                    modifier = Modifier.weight(1f),
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
                creationDate,
                creationTime,
                onShowDatePicker = onEditCreationDate,
                onShowTimePicker = onEditCreationTime,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
            )
        }

        if (shouldShowCategoryPicker) {
            CategoryPickerDialog(
                categories,
                onPickCategory = setCategory,
                onClose = { shouldShowCategoryPicker = false },
            )
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
    modifier: Modifier = Modifier,
    onShowCategoryPicker: (() -> Unit)? = null,
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
        trailingIcon = {
            if (onShowCategoryPicker != null) {
                IconButton(onClick = onShowCategoryPicker) {
                    Icon(
                        Icons.Rounded.MoreHoriz,
                        contentDescription = "Pick categories",
                    )
                }
            }
        },
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
        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
        label = { Text("Cost") },
        placeholder = { Text("0.00") },
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
    date: LocalDate,
    time: LocalTime,
    onShowDatePicker: () -> Unit,
    onShowTimePicker: () -> Unit,
    modifier: Modifier = Modifier,
) {
    val typography = MaterialTheme.typography
    val colors = MaterialTheme.colors

    Column(modifier = modifier) {
        Text(
            "Created At",
            style = typography.subtitle2.copy(
                color = colors.onSurface.copy(alpha = 0.6f)
            ),
        )
        Spacer(modifier = Modifier.height(4.dp))

        Row {
            CreationDatePicker(
                date,
                onShowDatePicker,
                modifier = Modifier.weight(1f),
            )
            Spacer(modifier = Modifier.width(8.dp))
            CreationTimePicker(
                time,
                onShowTimePicker,
                modifier = Modifier.weight(1f),
            )
        }
    }
}

@Composable
private fun CreationDatePicker(
    initialDate: LocalDate, onShowDatePicker: () -> Unit, modifier: Modifier
) {
    ClickableOutlinedTextField(
        initialDate.display(),
        onShowDatePicker,
        modifier = modifier,
        label = { Text("Date") },
        leadingIcon = {
            Icon(
                Icons.Rounded.CalendarToday,
                contentDescription = "Creation date",
            )
        },
    )
}

@Composable
private fun CreationTimePicker(
    initialTime: LocalTime, onShowTimePicker: () -> Unit, modifier: Modifier
) {
    ClickableOutlinedTextField(
        initialTime.display12Hour(),
        onShowTimePicker,
        modifier = modifier,
        label = { Text("Time") },
        leadingIcon = {
            Icon(Icons.Rounded.Schedule, contentDescription = "Creation time")
        },
    )
}

@Composable
private fun ClickableOutlinedTextField(
    value: String,
    onClick: () -> Unit,
    modifier: Modifier,
    label: @Composable () -> Unit,
    leadingIcon: @Composable () -> Unit
) {
    Box(modifier = modifier) {
        OutlinedTextField(
            value,
            {},
            modifier = Modifier.fillMaxWidth(),
            readOnly = true,
            singleLine = true,
            label = label,
            leadingIcon = leadingIcon,
        )

        Box(modifier = Modifier
            .matchParentSize()
            .clickable { onClick() })
    }
}

@OptIn(ExperimentalMaterialApi::class)
@Composable
private fun CategoryPickerDialog(
    categories: List<String>,
    onPickCategory: (String) -> Unit,
    onClose: () -> Unit,
) {
    AlertDialog(
        title = { Text("Select Category") },
        text = {
            Column(modifier = Modifier.verticalScroll(rememberScrollState())) {
                for (c in categories) {
                    ListItem(
                        text = { Text(c) },
                        modifier = Modifier.clickable {
                            onPickCategory(c)
                            onClose()
                        },
                    )
                }
            }
        },
        buttons = {
            ButtonBar(modifier = Modifier.fillMaxWidth()) {
                TextButton(onClick = onClose) { Text("CLOSE") }
            }
        },
        onDismissRequest = onClose,
        properties = DialogProperties(
            dismissOnBackPress = true,
            dismissOnClickOutside = false,
        ),
    )
}

private fun showDatePicker(
    fragmentManager: FragmentManager,
    initialDate: LocalDate,
    onPickDate: (LocalDate) -> Unit,
) {
    val picker = MaterialDatePicker.Builder.datePicker().apply {
        setTitleText("Set Reminder Date")
        setSelection(initialDate.toEpochMilli())
    }.build()

    picker.addOnPositiveButtonClickListener { epochMilli ->
        onPickDate(epochMilli.toLocalDate())
    }

    picker.show(fragmentManager, "datePicker")
}

private fun showTimePicker(
    fragmentManager: FragmentManager,
    initialTime: LocalTime,
    onPickTime: (LocalTime) -> Unit,
) {
    val picker = MaterialTimePicker.Builder().apply {
        setTitleText("Set Reminder Time")
        setTimeFormat(TimeFormat.CLOCK_12H)
        setHour(initialTime.hour)
        setMinute(initialTime.minute)
    }.build()

    picker.addOnPositiveButtonClickListener {
        onPickTime(LocalTime.of(picker.hour, picker.minute))
    }

    picker.show(fragmentManager, "timePicker")
}

@Preview
@Composable
fun ExpenseEditorPagePreview() {
    var category by remember { mutableStateOf("") }
    var cost by remember { mutableStateOf("") }
    var note by remember { mutableStateOf("") }
    val creationDate by remember { mutableStateOf(LocalDate.now()) }
    val creationTime by remember { mutableStateOf(LocalTime.now()) }
    val categories by remember {
        mutableStateOf(listOf("Food", "Commute", "Health"))
    }

    ExpenseEditorPage(
        category = category,
        cost = cost,
        note = note,
        creationDate = creationDate,
        creationTime = creationTime,
        categories = categories,
        setCategory = { category = it },
        setCost = { cost = it },
        setNote = { note = it },
        onEditCreationDate = {},
        onEditCreationTime = {},
        onNavigateUp = {},
        canSave = true,
        onSaveExpense = {},
    )
}