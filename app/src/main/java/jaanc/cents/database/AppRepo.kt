package jaanc.cents.database

import androidx.lifecycle.LiveData
import androidx.lifecycle.Transformations
import jaanc.cents.domain.Expense
import jaanc.cents.domain.ExpenseCategory

class AppRepo(private val database: AppDatabase) {
    private val expenseDao = database.expenseDao()

    val allExpenses: LiveData<List<Expense>> =
        Transformations.map(expenseDao.getAllLive()) { de ->
            de.map(DatabaseExpense::asDomain)
        }

    val allCategories = expenseDao.getAllCategoriesLive()

    suspend fun get(expenseId: Int): Expense? {
        return expenseDao.get(expenseId)?.let(DatabaseExpense::asDomain)
    }

    suspend fun add(expense: Expense) {
        expenseDao.insert(DatabaseExpense.of(expense))
    }

    suspend fun update(expense: Expense) {
        expenseDao.update(DatabaseExpense.of(expense))
    }

    suspend fun delete(expenseId: Int) {
        expenseDao.delete(expenseId)
    }

    suspend fun renameCategory(
        oldCategory: ExpenseCategory, newCategory: ExpenseCategory
    ) {
        expenseDao.renameCategory(oldCategory.name, newCategory.name)
    }
}