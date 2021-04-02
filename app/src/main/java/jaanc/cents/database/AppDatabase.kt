package jaanc.cents.database

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters

@Database(entities = [DatabaseExpense::class], version = 1)
@TypeConverters(
    ConverterAmount::class,
    ConverterExpenseCategory::class,
    ConverterLocalDateTime::class
)
abstract class AppDatabase : RoomDatabase() {
    companion object {
        private lateinit var instance: AppDatabase

        fun getInstance(context: Context): AppDatabase {
            return synchronized(this) {
                if (!::instance.isInitialized) {
                    instance = Room.databaseBuilder(
                        context.applicationContext,
                        AppDatabase::class.java,
                        "expenses"
                    ).build()
                }

                instance
            }
        }
    }

    abstract fun expenseDao(): DaoExpense
}