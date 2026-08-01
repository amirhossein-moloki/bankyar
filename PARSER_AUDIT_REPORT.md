# BankYar SMS Parser Architecture Audit & Root Cause Analysis

This document presents a comprehensive, high-fidelity audit and root-cause analysis of the original SMS Parser and Detection Engine of BankYar, satisfying the requirements of **PART 1 — Root Cause Analysis**.

---

## 1. Executive Summary

A full systemic audit of the SMS Parser and Detection Engine has revealed structural design flaws in the original parser pipeline. The original codebase relied on a monolithic, rigid, single-regex matching model with global fallback regexes shared across all 32 Iranian banks. Because individual banks did not have independent templates or decoupled parsing stages, any variation in Farsi phrasing, whitespace, punctuation, or multi-line structure resulted in either misclassification, complete parser failure, or deterministic scoring rejections.

---

## 2. Key Audit Findings & Root Causes

### A. Why Valid Transactions Are Rejected

1. **Unregistered Shortcode & Fallback Deficit:**
   The deterministic scoring system allocated **50 points** out of 100 for a verified Sender ID. If a message was received from an official numeric shortcode (e.g., `10004007` or `20002011`) that was not explicitly hardcoded in the bank's `senderIds` list, the pipeline fallback to keyword matching triggered. However, because the sender was unrecognized, the message could never receive the 50-point sender bonus. Even if it matched transaction keywords (+20), extracted an amount (+10), card suffix (+10), and post-balance (+10), its maximum possible score was **50/100**. Because the rejection threshold was strictly **`< 60`**, every single valid transaction received from a numeric shortcode or keyword-fallback was silently discarded/ignored.

2. **Rigid Amount Parser Filters:**
   The `AmountParser` evaluated numerals globally. If an SMS message contained standard Persian dates (e.g., `1402/12/29` or times like `14:35`), these numbers were sometimes stripped but often incorrectly matched or confounded with the transactional amount when formatting groupings (such as Rial vs. Toman) lacked space delimiters or utilized local Arabic decimal points (٫).

---

### B. Rules and Patterns That Are Too Strict

1. **Single Global Regular Expressions:**
   The original architecture defined global patterns in `RegexPatterns` for things like `balancePattern` and `referencePattern`. Iranian banks modify their SMS templates frequently. When a bank changed a word (e.g., using `موجودی:` instead of `مانده:` or putting additional whitespace/dashes), the global regexes failed to match, failing to extract critical fields, lowering the confidence score, and causing transaction rejection.

2. **Rigid Word Boundaries (`\b`):**
   Using `\b` boundaries in Farsi/Arabic scripts is highly problematic in regular expressions, because Farsi word boundaries are not recognized identically to English alphanumeric boundaries by standard regex engines (especially around non-spacing half-spaces, called *Nim-Spase* or `‌`). This caused localized patterns to fail silently on valid Persian texts.

---

### C. Bias Towards Debit Transactions (Debit-Oriented Design)

1. **Monolithic Binary Verbs Check:**
   The transaction direction was evaluated globally using a simple `creditVerbs.hasMatch(text)` and `debitVerbs.hasMatch(text)`. This is highly debit-oriented:
   - If a credit SMS contained a debit verb in its metadata (e.g., `"واریز مبلغ ۵۰۰,۰۰۰ ریال از کارت ..."`, where `"از کارت"` or `"برداشت"` is mentioned in the context of the sender's source), the parser matched both verbs.
   - When both matched, the fallback default was strictly: `else if (isCredit && isDebit) { return SmsTransactionType.debit; }`.
   - This default automatically coerced valid Credit/Deposit transactions into Debit/Withdrawals.
   - Direction detection was performed *before* extracting the amount and without analyzing template-specific context, leading to systemic directional errors.

---

### D. Incomplete Template Coverage per Bank

1. **The Shared Base Class Trap:**
   Individual bank files (e.g., `bank_melli.dart`, `bank_saman.dart`, etc.) were mere metadata shells declaring `bankId`, `bankName`, `senderIds`, and `keywords`. They completely inherited their parsing logic from `BaseBankParser`.
   - None of the 32 banks had specialized independent templates.
   - Distinct transaction types such as **POS Purchases**, **ATM Withdrawals**, **Card-to-Card Transfers (کارت به کارت)**, **Paya (پایا)**, **Satna (ساتنا)**, **Pol (پل)**, **Salary (حقوق)**, **Interest (سود)**, and **Refunds (برگشت وجه)** were all funneled through the same generic fallback parser.

---

### E. Unsupported SMS Patterns

The following common Iranian SMS formats were completely unsupported or parsed incorrectly:
- **Unified Amount & Sign:** `مبلغ:500,000+` or `مبلغ:500,000-` (signs attached directly to numbers without spaces).
- **Description-First Transfers:** SMS formats where description blocks preceded numeric figures, causing amount-card identifier confusion.
- **Neo-Bank Inline Statuses:** BluBank or Bankino notifications utilizing emojis, localized Nim-Spase, or dynamic English headers combined with Persian bodies.

---

## 3. Proposal for the Redesigned Architecture

To solve these systemic failures permanently, the engine is being refactored to support a **100% independent, stage-based pipeline, a plug-in template registry, confidence scoring based on actual attribute extraction, voting-based direction detection, and multi-stage merchant cleaning**.

*Refer to the subsequent source code implementations for the complete architectural redesign.*
