package jaanc.cents.ui.expensestatspage

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import jaanc.cents.database.AppDatabase
import jaanc.cents.database.AppRepo

class ExpenseStatsPageViewModelFactory(private val application: Application) :
    ViewModelProvider.Factory {

    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(ExpenseStatsPageViewModel::class.java)) {
            @Suppress("UNCHECKED_CAST") return ExpenseStatsPageViewModel(
                application
            ) as T
        }

        throw IllegalArgumentException("Unable to construct ${ExpenseStatsPageViewModel::class.simpleName}")
    }
}

class ExpenseStatsPageViewModel(application: Application) :
    AndroidViewModel(application) {

    private val repo = AppRepo(AppDatabase.getInstance(application))
}