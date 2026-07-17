# BankYar Design Philosophy, Language, and UX Principles

## Executive Summary
This document establishes the official Design Philosophy, Design Language, and UX Governance for BankYar. As an Offline-First, Privacy-First banking SMS management application targeting the Iranian market (supporting Persian RTL natively and preparing for future cross-platform and English/Arabic expansion), BankYar manages highly sensitive financial transaction data.

To bridge the gap between high-level architectural declarations and physical implementation, this document serves as the absolute, non-negotiable design authority for all screens, layouts, states, motions, and user flows. This philosophy prioritizes information utility over decorative aesthetics, absolute user trust over visual excitement, functional simplicity over unnecessary interaction, and predictable accessibility over design novelty.

---

## 1. Product Vision
BankYar is the world's most trusted, silent, and private offline-only financial companion. Our vision is to empower individuals to master their financial life without ever surrendering their private data to cloud servers. The app intercepts scattered, chaotic banking communications and translates them instantly into an on-device, structured, and insightful financial ledger, returning complete ownership of financial truth back to the individual.

---

## 2. Design Vision
Our design vision is to create a digital experience that behaves like a high-precision, premium physical instrument: silent, completely reliable, and instantly understandable. It does not compete for the user's attention. It does not introduce cognitive noise. It presents financial truth with absolute clarity, creating a safe, calm harbor where users can observe and make decisions about their wealth with confidence.

---

## 3. Product Personality
BankYar’s product personality is defined by three main characteristics:
* **Stoic:** Silent, calm, and focused. The product remains in the background until explicitly called upon. It has no artificial animations, no gamified achievements, and no unnecessary messages or alerts.
* **Precise:** Information is displayed with surgical accuracy. Transactions, balances, dates, and category tags are structured with structured layouts, preserving absolute correctness.
* **Empowering:** It does not lecture the user or prescribe financial behavior. Instead, it processes complex inputs and organizes them cleanly, letting the user derive their own insights.

---

## 4. Brand Personality
Our brand identity is built on a foundation of professional trust and safety:
* **The Guardian:** Reliable and secure. Our brand feels solid, unchanging, and absolute. It represents an offline vault protecting sensitive financial data.
* **The Analyst:** Smart and objective. The brand is professional and serious, presenting data without promotional language or emotional bias.
* **The Minimalist:** Elegant and uncluttered. We respect the user's cognitive capacity, presenting only what is essential and stripping away all decorative elements.

---

## 5. Emotional Design Goals
The experience must communicate and trigger six distinct emotional states:
1. **Trust:** Reassured that data is completely private and local.
2. **Calmness:** Peaceful and anxiety-free when reviewing financial balances.
3. **Clarity:** Instantly understanding cash flow, spending habits, and trends.
4. **Reliability:** The system performs flawlessly under any network or battery scenario.
5. **Speed:** Tasks and information are retrieved with minimal interaction cost.
6. **Professionalism:** The visual presentation is consistent, mature, and rigorous.

---

## 6. User Experience Philosophy
Every interaction must respect the user’s cognitive, emotional, and physical boundaries. We reject "delight" when it conflicts with utility. The user experience is optimized for fast extraction of facts and immediate task execution. We treat user attention as a finite, precious asset that must never be squandered.

---

## 7. Design Language
Our design language is structured around content utility and predictable patterns:
* **Content as Interface:** Layout boundaries, grouping containers, and reading lines are defined by the structure of the text and figures themselves. Decorative embellishments (like complex icons or heavy backgrounds) are strictly avoided.
* **Consistency over Novelty:** Standard UI elements are used predictably. Buttons behave exactly as expected, list views scroll naturally, and navigation patterns are identical across every flow.

---

## 8. Visual Philosophy
The interface is a canvas for financial data, characterized by:
* **Flat Surfaces:** Flat structural cards are used to group related fields, avoiding unnecessary depth layers.
* **Functional Visual Cues:** Visual elements (such as thin dividers or subtle status markers) are used only to separate unrelated information or display actionable states, not as decorative filler.
* **Intentional Focus:** Visual contrast is reserved strictly for primary numbers (amounts) and primary navigation triggers.

---

## 9. Financial Product Design Principles
* **Mathematical Rigor:** Financial numbers are never truncated, rounded, or visually obscured unless explicitly collapsed by the user for privacy.
* **Transaction Integrity:** Every transaction card displays its matching status (e.g., fully parsed, manually added, or low-confidence) to prevent ambiguity.
* **Balance Verification:** Any derived balance is clearly distinguished from raw transactional amounts.

---

## 10. Privacy-First Design Principles
* **Local Confidentiality by Default:** No sensitive financial information or transaction lists are visible on the dashboard without unlocking the app first.
* **Window Redaction:** The layout remains blank or heavily blurred inside the operating system's task switcher card to prevent visual leaks.
* **Input Privacy:** Forms do not pre-fill or cache financial details outside of the encrypted SQLCipher environment.

---

## 11. Offline-First UX Principles
* **Perfect Status Continuity:** The application does not show "offline warnings" or "no internet connection" alerts. It simply functions at 100% capacity at all times.
* **Instant Verification:** State mutations (such as updating categories, notes, or rules) are processed and committed instantly to the local database, with changes rendered immediately on screen.
* **Local Data Controls:** Secure backup and restore triggers are displayed in plain language, detailing file ownership and export encryption parameters.

---

## 12. Cognitive Load Reduction Strategy
* **Chunking Information:** Data fields are grouped into logical, semantic cards (such as Origin, Transaction Details, and Category Rules).
* **Consistent Visual Grid:** Layout structures align to a strict structural grid, enabling users to scan different screens using identical eye movements.
* **Low Density Options:** Complex dashboards are avoided; instead, clear summaries are presented with details accessible via simple expanders.

---

## 13. Progressive Disclosure Strategy
* **Contextual Detail Levels:** High-level lists display only the core facts (Amount, Date, and Merchant). Detailed parameters (such as the raw SMS text or system parsing rules) are hidden behind a single-tap transaction inspector.
* **Surgical Controls:** Advanced tools (such as regex builders or diagnostic file exporters) are tucked away in sub-menus, preventing them from cluttering everyday navigation.

---

## 14. Information Hierarchy
Information is arranged strictly by transactional significance:
1. **The Number:** The financial amount of the transaction, representing the highest visual emphasis.
2. **The Counterparty:** The merchant or financial sender.
3. **The Date & Time:** The timestamp of the transaction.
4. **The Meta-tags:** Categories, custom notes, and hashtags.

---

## 15. Reading Experience Philosophy
* **RTL Optimized Typography:** Persian numbers and text are rendered with proper character tracking and line height to ensure effortless reading.
* **Clean Typographic Scale:** Font sizes are distinct and highly contrasted, prioritizing readability over decorative styling.
* **High Contrast Copy:** Text colors maintain high contrast against their background, meeting strict accessibility targets.

---

## 16. Content-First Design
The design of any screen begins with the actual raw text and numbers of the banking messages, not layout containers. The interface adjusts dynamically to wrap, align, and structure real-world Persian banking SMS strings without clipping or awkward line breaks.

---

## 17. One-Hand Mobile Usage Philosophy
* **The Interaction Zone:** Primary interactive triggers, custom lists, and button groups are located within the lower half of the screen, ensuring comfortable one-handed reach.
* **Top-Down Display:** Reading content resides in the top half, while actionable controls occupy the bottom half.
* **Predictable Bottom Sheets:** Interactive settings, categorization forms, and details expand as stable bottom sheets, bringing controls directly to the user's thumb.

---

## 18. Mobile-First Principles
* **Tappable Comfort:** All interactive touch targets are large and well-spaced, preventing accidental triggers.
* **No Side Gestures:** Horizontal swipes are reserved strictly for high-level tab switches, ensuring users do not accidentally trigger destructive actions (like deletions) while scrolling.
* **System-Native Feedback:** Interaction confirmations leverage system haptics and native sheets to feel familiar.

---

## 19. RTL-First Design Principles
* **Mirrored Flow Direction:** Layouts flow from right to left (RTL) for Persian. Chronological feeds, reading paths, and swipe gestures are mirrored naturally.
* **Persian Font Adaptation:** Typographic layouts are designed specifically around the baseline and line-height requirements of Persian fonts.
* **Icon Mirroring:** Directional icons (such as back arrows, progress indicators, and text fields) are mirrored dynamically based on the active locale.

---

## 20. Accessibility Philosophy
* **Color Independence:** Meaning is never conveyed solely by color (e.g., green for income and red for expense). Layouts use clear signs, text labels, and structural shapes (such as plus/minus symbols or descriptive badges) alongside color.
* **Robust Contrast:** Text, icons, and focus indicators maintain strong, legible contrast ratios under all lighting conditions.
* **Screen Reader Integrity:** Every interactive layout and data element is labeled with semantic descriptions for screen readers.

---

## 21. Trust-Building Principles
* **No Magic Operations:** Automatic processes (such as categorizations or regex parses) are labeled clearly, allowing users to inspect why a specific category was assigned.
* **Explicit Local Assurances:** The app explicitly informs the user that data is saved locally on their device, clarifying that zero network permissions are requested.
* **No Forced Upgrades:** The application does not lock functions or force user updates, maintaining system stability indefinitely.

---

## 22. Error Prevention Philosophy
* **Destructive Confirmation:** Destructive actions (such as purging databases or deleting templates) require explicit, secondary confirmations (such as entering a PIN or confirming a prompt).
* **Validation Prior to Save:** Text entry fields, regex patterns, and CSV statements are validated in real-time, preventing invalid inputs from entering the database.
* **Graceful Parsing Fallback:** If parsing fails, the message is saved as an unparsed item rather than failing silently, allowing manual correction.

---

## 23. User Control Philosophy
* **Complete Override Capability:** Every automated classification, categorization rule, and parsed amount can be overridden manually by the user.
* **Data Portability:** Users can export their entire financial ledger, templates, and categories at any time, or purge all local files permanently.
* **Opt-In Rules:** Automatic matching rules are fully customisable, letting users edit, disable, or delete them at will.

---

## 24. Feedback Philosophy
* **Immediate Confirmations:** Every user action (such as saving a note or updating a category) receives immediate visual feedback, completing within under 100 milliseconds.
* **System Native Sheets:** Confirmations use standard native modal sheets, ensuring high-speed rendering and familiar feedback.
* **Non-Intrusive Errors:** System errors are presented via clear inline alerts or bottom banners that do not disrupt the active flow.

---

## 25. Interaction Consistency
* **Identical Action Results:** A tap on a transaction card always opens the detailed transaction inspector. A swipe always performs the same transition. Buttons use identical shapes and sizes across every feature.
* **Predictable Placement:** Core actions (like searching, editing, and saving) reside in identical screen locations across different contexts.

---

## 26. Navigation Philosophy
* **Linear Hierarchy:** The app uses a simple, flat navigation structure with distinct main sections (Ledger, Analytics, Rules, Diagnostics, Settings) accessible via a persistent bottom navigation bar.
* **No Nesting Bloat:** Deeply nested screens are prohibited. Sub-pages (such as rule editors) exist only one layer deep, returning users immediately to the parent context.
* **Standard Back Actions:** The system back button or swipe gesture always returns the user to the immediate previous screen.

---

## 27. Motion Philosophy
* **No Decorative Animations:** Animations are strictly prohibited if they are merely decorative. Transitions and transitions are used only to communicate structural relationships between screens (such as expanding a card into a details page) or confirm a system status change.
* **Ultra-Fast Durations:** Motion durations are kept short (typically under 200 milliseconds) and utilize linear eases, preventing them from slowing down tasks.

---

## 28. Performance Perception Philosophy
* **Constant Frame Rates:** Scroll feeds maintain smooth frame rates by keeping heavy analytical calculations off the main rendering thread.
* **Immediate State Updates:** Interactive controls render their updated states immediately on-screen before verifying database confirmation, keeping the interface feeling instantaneous.

---

## 29. Notification Experience
* **No Promotional Alerts:** The app never sends marketing notifications, behavior reminders, or promotional alerts.
* **Transactional Integrity:** Notifications are reserved strictly for real-time background SMS parsing, confirming background ingestion quietly and securely.

---

## 30. Empty State Philosophy
* **Actionable Guidance:** Empty screens (such as a ledger with no transactions or a rules list with no entries) never present blank voids. Instead, they provide brief, reassuring context and a clear primary action to get started.
* **Clear Reassurance:** On initial launch, empty states explain why there is no data and guide the user on granting permissions or manually importing their statement.

---

## 31. Loading Experience Philosophy
* **Instant Structured Layouts:** Feeds load instantly using stable structural layouts, preventing awkward jumps as content renders.
* **No Spinner Blocks:** Avoid full-screen loading spinner blocks; instead, allow the user to navigate and inspect the UI freely while background tasks run.

---

## 32. Success Feedback Philosophy
* **Calm Confirmations:** Success states (such as a saved rule, a completed database backup, or a verified login) use calm, brief visual feedback.
* **Self-Dismissing Sheets:** Feedback sheets dismiss themselves automatically, returning the user to their active task with zero extra taps.

---

## 33. Financial Dashboard Philosophy
* **Information First:** The main dashboard is a clean, structural feed of transactions, comparison charts, and essential summaries. It avoids decorative gauges, complex charts, or heavy decorative cards.
* **Immediate Summaries:** Incomes, expenses, and net cash flow are presented in clear, readable figures at the top of the dashboard, updating instantly as transactions are parsed.

---

## 34. Security UX Guidelines
* **The Lock Shield:** When resuming the application, the biometric or PIN entry screen presents a clean, simple layout, signaling absolute safety without complex decorative details.
* **Concealed Previews:** The layout hides sensitive fields and transaction records when the user enters the task-switching menu, protecting privacy from bystanders.

---

## 35. Future Evolution Principles
* **Consistent Core Rules:** When adding new features (such as local Wi-Fi sync, PDF exports, or heuristic parsers), the core layout structures, accessibility requirements, and privacy-first constraints remain unchanged.
* **Preserving Simplicity:** Visual novelty is strictly rejected. New interfaces must adapt to existing layouts, ensuring long-term consistency.

---

## 36. Design Principles Matrix

The following matrix defines the priority weight and design governance rules for the primary dimensions of the BankYar design system:

| Design Dimension | Primary Objective | Trade-off Decision Rule | Priority Weight | Governance Status |
| :--- | :--- | :--- | :---: | :---: |
| **Information Accessibility** | Clear visual readability and proper screen reader labeling. | Accessibility ALWAYS takes priority over decorative layouts. | **Highest** | Mandatory |
| **Privacy / Security** | Protecting sensitive financial details from local exposure. | Local security controls ALWAYS take priority over convenience. | **High** | Mandatory |
| **Interface Simplicity** | Low cognitive load and minimal decorative noise. | Clean structural utility ALWAYS takes priority over creative layouts. | **High** | Mandatory |
| **Interaction Speed** | Fast task execution and minimal interaction cost. | Performance perception ALWAYS takes priority over slow animations. | **Medium** | Mandatory |

---

## 37. Design Laws

Every future screen, feature, and interaction layout in BankYar must strictly comply with these design laws:

1. **One Primary Goal Per Screen:** Every layout must focus on a single core task, displaying only relevant controls.
2. **Information Before Decoration:** Visual embellishments, decorative illustrations, and complex icons are prohibited.
3. **Maximum Two Primary Actions:** Screens must not present more than two primary buttons, reducing choice anxiety.
4. **Recognition Over Recall:** Actions, categories, and tags must be displayed clearly, ensuring users do not have to memorize previous steps.
5. **No Surprise Behaviors:** Standard elements (buttons, fields, lists) must function predictably.
6. **Low Interaction Cost:** Common tasks (such as assigning a category or adding a note) must be achievable in two taps or fewer.
7. **Privacy by Default:** Sensitive financial details must be concealed on launch until the user unlocks the app.
8. **RTL Native Alignment:** Persian layouts must be built RTL-first, ensuring natural reading and scrolling patterns.

---

## 38. UX Decision Matrix

Use this matrix to resolve design conflicts during feature planning:

| Conflict Scenario | Option A (Exciting/Decorative) | Option B (Simple/Utility) | Resolution Decision Rule |
| :--- | :--- | :--- | :--- |
| **Visualizing Categories** | Colorful 3D pie charts with detailed gradients. | Flat structural donut charts with text percentages. | **Option B.** Flat structural charts preserve readability, reducing visual clutter and rendering overhead. |
| **Assigning Categories** | Multi-gesture drag-and-drop interaction. | Stable bottom sheet with large, clickable category chips. | **Option B.** Clicking category chips has a lower interaction cost and is easier to perform one-handed. |
| **Presenting Data** | Complex visual dashboards with multiple indicators. | Clean, structured vertical lists. | **Option B.** Structured vertical lists reduce cognitive load, making financial records easier to scan. |

---

## 39. Anti-Pattern Catalog

The following visual and interaction anti-patterns are strictly prohibited:

* **Overloaded Dashboards:** Do not crowd multiple widgets, charts, and summaries onto a single screen.
* **Heavy Gradients & Neumorphism:** Avoid deep 3D-styled cards, heavy shadows, and glowing gradients.
* **Unnecessary Animations:** Decorative spin transitions, complex loading shapes, and slow slide transitions are prohibited.
* **Hidden Actions:** Primary actions (such as saving, editing, or deleting) must not be concealed behind non-standard gestures (like long-pressing or double-tapping).
* **Multiple Floating Buttons:** Do not place multiple floating actions on a single screen.

---

## 40. Governance Rules

* **Design Consistency Priority:** Long-term design consistency takes precedence over visual novelty. Every screen must utilize our standard, flat layout patterns.
* **Explainable Visual Decisions:** Every design choice (such as adding a visual cue or placing a control) must be justified based on usability, accessibility, or privacy benefits.
* **Compliance Checks:** All new features must pass the official Design Review Checklist before implementation.

---

## 41. Trade-Off Analysis

1. **Absolute Privacy vs. Cloud Convenience:**
   - *The Trade-off:* Eliminating cloud-sync requires users to manually export and import backup files.
   - *Rationale:* User trust is our highest priority. Verifiable, 100% offline local storage protects user privacy, which outweighs the convenience of automated cloud sync.
2. **Minimal Animations vs. Interface Delight:**
   - *The Trade-off:* The app avoids slow, playful transitions, resulting in a sober, serious interface.
   - *Rationale:* BankYar is a precise financial tool, not an entertainment app. Silent, ultra-fast performance reduces user anxiety and accelerates task execution.

---

## 42. Future Evolution Strategy

* **Scale via Layout Consistency:** As features expand, they must be integrated into our existing screen structures. For example, local Wi-Fi sync controls are located within the Settings page, maintaining our flat navigation hierarchy.
* **Component-First Expansion:** New features must compose existing layout patterns (such as standard bottom sheets and flat cards) rather than introducing custom layouts.

---

## 43. Review Checklist

Before implementing a screen, verify compliance against this checklist:

- [ ] Does the screen focus on a single, clear primary goal?
- [ ] Is all sensitive financial information concealed on launch?
- [ ] Are all Persian text layouts aligned RTL-first?
- [ ] Do interactive elements avoid complex gestures, relying on clear clicks instead?
- [ ] Are all decorative gradients, 3D elements, and unnecessary animations excluded?
- [ ] Does the screen maintain clear visual contrast and accessibility labeling?

---

## 44. Architecture Alignment

This design philosophy is aligned with the **BankYar Architecture Baseline v1.0**:
* **Thread Separation:** The UI thread remains responsive (60fps+) by running intensive tasks (like processing statements or executing backups) in separate background processes.
* **Zero Network Manifest:** No design element relies on external assets, fonts, or remote trackers, ensuring perfect offline operation.
* **Secure Cache Erasure:** Sensitive details are purged from temporary layouts immediately after the application is sent to the background, preventing visual exposure.
