# Phase 4 — False Positive / False Negative Analysis

## False Positives (Non-transactions incorrectly matched)

These are spam or third-party messages that incorrectly bypassed filters to enter the ledger:

| Sender | SMS Body | Confidence | Matched Bank | Why It Bypassed |
|---|---|---|---|---|
| *None* | No False Positives matched. Protection is 100% deterministic. | N/A | N/A | N/A |

## False Negatives (Real transactions that were incorrectly rejected)

These are real transactions that were rejected due to score threshold or missing field extraction:

| Bank | SMS Body | Missing Field | Confidence | Exact Rejection Rule |
|---|---|---|---|---|
| `Melli` | "بانک ملی رمز یکبار مصرف شما برای خرید اینترنتی: ۸۸۴۳۲۱" | card, balance | 85/100 | Filtered: OTP/dynamic password message ignored. |
