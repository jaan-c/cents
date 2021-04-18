package jaanc.cents.ui.expensestatspage

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview

@Composable
fun ExpenseStatsPage() {
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Stats") })
        },
    ) {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.fillMaxSize()
        ) {
            Text("Stats goes here")
        }
    }
}

@Preview
@Composable
fun ExpenseStatsPagePreview() {
    ExpenseStatsPage()
}