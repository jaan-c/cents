package jaanc.cents.ui.expenselistpage

import android.app.Application
import android.content.Context
import androidx.lifecycle.AndroidViewModel
import jaanc.cents.database.AppDatabase
import jaanc.cents.database.AppRepo

class ExpenseListPageViewModel(context: Context) :
    AndroidViewModel(context.applicationContext as Application) {
    
    private val repo = AppRepo(AppDatabase.getInstance(context))

    val allExpenses = repo.allExpenses
}