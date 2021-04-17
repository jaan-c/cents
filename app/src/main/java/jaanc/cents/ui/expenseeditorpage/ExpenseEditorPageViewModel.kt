package jaanc.cents.ui.expenseeditorpage

import android.app.Application
import androidx.lifecycle.*
import jaanc.cents.database.AppDatabase
import jaanc.cents.database.AppRepo
import jaanc.cents.domain.Amount
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

class ExpenseEditorPageViewModelFactory(
    private val application: Application, private val expenseId: Int
) : ViewModelProvider.Factory {
    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(ExpenseEditorPageViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST") return ExpenseEditorPageViewModel(
                application, expenseId
            ) as T
        }

        throw IllegalArgumentException("Unable to construct ${ExpenseEditorPageViewModel::class.simpleName}")
    }

}

class ExpenseEditorPageViewModel(
    application: Application, private val expenseId: Int
) : AndroidViewModel(application) {

    private val repo = AppRepo(AppDatabase.getInstance(application))

    private val _categoryText = MutableLiveData("")
    val categoryText: LiveData<String> = _categoryText

    private val _costText = MutableLiveData("")
    val costText: LiveData<String> = _costText

    private val _noteText = MutableLiveData("")
    val noteText: LiveData<String> = _noteText

    private val _creationDate = MutableLiveData(LocalDate.now())
    val creationDate: LiveData<LocalDate> = _creationDate

    private val _creationTime = MutableLiveData(LocalTime.now())
    val creationTime: LiveData<LocalTime> = _creationTime

    val existingCategories =
        Transformations.map(repo.allCategories) { cs -> cs.map { c -> c.name } }

    val canSave: LiveData<Boolean> =
        Transformations.map(_costText) { costText ->
            try {
                Amount.of(costText)
                true
            } catch (_: NumberFormatException) {
                false
            }
        }

    private val _shouldShowDatePicker = MutableLiveData(false)
    val shouldShowDatePicker: LiveData<Boolean> = _shouldShowDatePicker

    private val _shouldShowTimePicker = MutableLiveData(false)
    val shouldShowTimePicker: LiveData<Boolean> = _shouldShowTimePicker

    private val _shouldNavigateUp = MutableLiveData(false)
    val shouldNavigateUp: LiveData<Boolean> = _shouldNavigateUp

    init {
        viewModelScope.launch {
            val expense = withContext(Dispatchers.IO) {
                repo.get(expenseId)
            }

            if (expense != null) {
                setCategoryText(expense.category.name)
                setCostText(expense.cost.toString())
                setNoteText(expense.note)
                setCreationDate(expense.createdAt.toLocalDate())
                setCreationTime(expense.createdAt.toLocalTime())
            }
        }
    }

    fun setCategoryText(newCategoryText: String) {
        _categoryText.value = newCategoryText
    }

    fun setCostText(newCostText: String) {
        _costText.value = newCostText
    }

    fun setNoteText(newNoteText: String) {
        _noteText.value = newNoteText
    }

    fun setCreationDate(newCreationDate: LocalDate) {
        _creationDate.value = newCreationDate
    }

    fun setCreationTime(newCreationTime: LocalTime) {
        _creationTime.value = newCreationTime
    }

    fun saveExpense() {
        if (!canSave.value!!) {
            throw IllegalStateException("Expense not saveable.")
        }

        viewModelScope.launch {
            val expense = Expense(
                expenseId,
                ExpenseCategory(categoryText.value!!.trim()),
                Amount.of(costText.value!!),
                noteText.value!!.trim(),
                LocalDateTime.of(creationDate.value!!, creationTime.value!!),
            )

            withContext(Dispatchers.IO) {
                if (expense.id == Expense.UNSET_ID) {
                    repo.add(expense)
                } else {
                    repo.update(expense)
                }
            }

            navigateUp()
        }
    }

    fun navigateUp() {
        _shouldNavigateUp.value = true
    }

    fun doneNavigatingUp() {
        _shouldNavigateUp.value = false
    }

    fun showDatePicker() {
        _shouldShowDatePicker.value = true
    }

    fun doneShowingDatePicker() {
        _shouldShowDatePicker.value = false
    }

    fun showTimePicker() {
        _shouldShowTimePicker.value = true
    }

    fun doneShowingTimePicker() {
        _shouldShowTimePicker.value = false
    }
}