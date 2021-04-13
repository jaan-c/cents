package jaanc.cents.ui.widgets

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Text
import androidx.compose.material.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun ButtonBar(modifier: Modifier = Modifier, content: @Composable () -> Unit) {
    Row(
        horizontalArrangement = Arrangement.End,
        verticalAlignment = Alignment.CenterVertically,
        modifier = modifier.padding(16.dp),
    ) {
        content()
    }
}

@Preview()
@Composable
fun ButtonBarPreview() {
    ButtonBar {
        TextButton({}) { Text("CANCEL") }
        TextButton({}) { Text("OK") }
    }
}