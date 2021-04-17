package jaanc.cents.ui.expenseeditorpage

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material.OutlinedTextField
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun ClickableOutlinedTextField(
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