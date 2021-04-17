package jaanc.cents.ui.expenselistpage

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import jaanc.cents.database.AppDatabase
import jaanc.cents.database.AppRepo

class ExpenseListPageViewModelFactory(private val application: Application) :
    ViewModelProvider.Factory {
    
    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(ExpenseListPageViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST") return ExpenseListPageViewModel(
                application
            ) as T
        }

        throw IllegalArgumentException("Unable to construct ${ExpenseListPageViewModel::class.simpleName}")
    }
}

class ExpenseListPageViewModel(application: Application) :
    AndroidViewModel(application) {

    private val repo = AppRepo(AppDatabase.getInstance(application))

    val allExpenses = repo.allExpenses
}