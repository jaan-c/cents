package jaanc.cents.database

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Update
import jaanc.cents.domain.ExpenseCategory

@Dao
interface DaoExpense {
    @Query("SELECT * FROM Expenses WHERE id = :id")
    suspend fun get(id: Int): DatabaseExpense?

    @Query("SELECT * FROM Expenses ORDER BY createdAt DESC")
    fun getAllLive(): LiveData<List<DatabaseExpense>>

    @Insert
    suspend fun insert(expense: DatabaseExpense)

    @Update
    suspend fun update(expense: DatabaseExpense)

    @Query("DELETE FROM Expenses WHERE id = :expenseId")
    suspend fun delete(expenseId: Int)

    @Query("SELECT DISTINCT category FROM Expenses ORDER BY category ASC")
    fun getAllCategoriesLive(): LiveData<List<ExpenseCategory>>

    @Query("UPDATE Expenses SET category = :newName WHERE category = :oldName")
    suspend fun renameCategory(oldName: String, newName: String)
}