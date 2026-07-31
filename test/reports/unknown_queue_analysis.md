# Phase 3 — Unknown Queue Analysis

This report audits messages that failed parsing or were classified as unknown.

## Dataset Statistics
- **Total SMS Evaluated:** 32
- **Bank SMS Detected:** 28
- **Financial Transactions (Ledger):** 23
- **OTP Messages (Ignored):** 2
- **Security Alerts (Ignored):** 1
- **Promotions (Ignored):** 1
- **Unknown Messages:** 0

## Unknown Messages Audit Queue

| Sender | SMS Preview | Failure Reason | Confidence | Suggested Template |
|---|---|---|---|---|
| `Melli` | "بانک ملی رمز یکبار مصرف شما برای خرید ای..." | Early Ignored: OTP/dynamic code is not a financial transaction. | 85/100 | `BankSmsTemplate` match |
| `BluBank` | "بلو بفرمایید رمز پویا خرید اسنپ مبلغ: 74..." | Early Ignored: OTP/dynamic code is not a financial transaction. | 85/100 | `BankSmsTemplate` match |
| `B.Mellat` | "بانک ملت مشتری گرامی، رمز همراه بانک شما..." | Early Ignored: Classification is bank_security. | 70/100 | `BankSmsTemplate` match |
| `Saman` | "بانک سامان مشتری گرامی، سررسید قسط تسهیل..." | Early Ignored: Classification is bank_loan. | 90/100 | `BankSmsTemplate` match |
| `Tejarat` | "بانک تجارت جشنواره فیروزه‌ای بانک تجارت ..." | Early Ignored: Classification is bank_promotional. | 70/100 | `BankSmsTemplate` match |
