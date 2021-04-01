package jaanc.cents.utils

import jaanc.cents.domain.Amount

fun Amount.display(currency: String = "₱"): String {
    return "$currency$unit.${cent.toString().padStart(2, '0')}"
}