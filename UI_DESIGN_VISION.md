# BankYar Enterprise UI Design Vision Specification
## Version 1.0.0 — Design-to-Implementation Visual System Blueprint

---

## 1. Executive Summary

This document establishes the official and authoritative UI Design Vision for BankYar Version 1. Operating as the absolute operational blueprint and visual standard for human-AI interaction, this specification defines the overall visual direction, interaction quality, emotional experience, consistency rules, and usability goals for the entire application.

As an offline-first, privacy-first mobile finance platform designed natively for the Persian language (RTL) on Android, BankYar manages highly sensitive transaction metadata on-device under strict zero-network constraints. The interface must balance professional rigor with elegant minimal aesthetics. It behaves as a high-precision, premium physical instrument: silent, completely reliable, and instantly understandable.

This design vision is fully aligned with all baseline specifications (PRD, Architecture, Design Token Architecture, Component Library, Navigation Specification, and Semantic Color System) and maintains absolute compliance with zero hardcoded visual styles, hex colors, physical measurements, or platform code.

---

## 2. Design Vision

### Product Vision
BankYar is the world's most trusted, silent, and private offline-only financial companion. Our vision is to empower individuals to master their financial lives without ever surrendering their private data to cloud servers. The app intercepts scattered, chaotic banking communications and translates them instantly into an on-device, structured, and insightful financial ledger, returning complete ownership of financial truth back to the individual.

### Design Vision
Our design vision is to create a digital experience that behaves like a high-precision, premium physical instrument: silent, completely reliable, and instantly understandable. It does not compete for the user's attention or introduce cognitive noise. It presents financial truth with absolute clarity, creating a safe, calm harbor where users can observe and make decisions about their wealth with confidence. This overall visual system treats user attention as a finite, precious asset that must never be squandered.

### Product Personality
BankYar's product personality is defined by three main characteristics:
* **Stoic:** Silent, calm, and focused. The product remains in the background until explicitly called upon. It has no artificial animations, no gamified achievements, and no unnecessary messages or alerts.
* **Precise:** Information is displayed with surgical accuracy. Transactions, balances, dates, and category tags are structured with structured layouts, preserving absolute correctness.
* **Empowering:** It does not lecture the user or prescribe financial behavior. Instead, it processes complex inputs and organizes them cleanly, letting the user derive their own insights.

### Brand Personality
Our brand identity is built on a foundation of professional trust and safety:
* **The Guardian:** Reliable and secure. Our brand feels solid, unchanging, and absolute. It represents an offline vault protecting sensitive financial data.
* **The Analyst:** Smart and objective. The brand is professional and serious, presenting data without promotional language or emotional bias.
* **The Minimalist:** Elegant and uncluttered. We respect the user's cognitive capacity, presenting only what is essential and stripping away all decorative elements.

### Emotional Experience & Emotional Design Goals
The experience must communicate and trigger six distinct emotional states:
1. **Trust:** Reassured that data is completely private, local, and protected.
2. **Calmness:** Peaceful and anxiety-free when reviewing financial balances.
3. **Clarity:** Instantly understanding cash flow, spending habits, and trends.
4. **Reliability:** The system performs flawlessly under any network or battery scenario.
5. **Speed:** Tasks and information are retrieved with minimal interaction cost.
6. **Professionalism:** The visual presentation is consistent, mature, and rigorous.

### Visual Story
The visual narrative of BankYar is the journey from **"Chaos to Order."** The raw, incoming text messages from Persian banks represent chaotic, fragmented, and stressful streams of data. The visual design system intercepts this stream and transforms it into structured, calm, and clean layers of financial clarity.
This visual story is told through the gradual refinement of elements:
* **The Intercept:** The raw SMS text is preserved exactly to build trust, representing the raw data input.
* **The Structure:** Flat, clean container blocks group the data, instantly organizing information by metadata types.
* **The Insight:** Soft, semantic highlights draw immediate focus to the numbers and transaction directions.

### Premium Feel Strategy
A premium experience is not defined by decoration, but by the meticulous control of execution details. BankYar achieves its premium feel through:
* **Precise Grid Alignment:** Everything aligns perfectly to a unified baseline, creating a sense of mechanical precision.
* **Optimal Spacing:** Generous whitespace around content ensures the interface never feels crowded.
* **High-Contrast Typography:** Clean typography weights establish an effortless hierarchy.
* **Tactile Feedback:** Low-latency transitions and physical haptic cues make interactive controls feel substantial.

### User Trust Strategy & Trust-building Principles
User trust is our highest priority. To build absolute trust in an offline application:
* **Verifiable Offline Operations:** The interface explicitly highlights that zero network permissions are requested.
* **No Magic Transformations:** Every automated action (such as categorizations or regex parses) is transparent and can be inspected to see why a specific category was assigned.
* **Complete Data Ownership:** The user has total control to override automated classifications, edit rules, or purge all local files permanently.

### Security Perception & Security UX Guidelines
Security must not only exist; it must be felt. Security is communicated visually through:
* **The Lock Shield:** When resuming the application, the PIN or biometric entry screen presents a clean, simple layout, signaling absolute safety without complex decorative details.
* **Concealed Previews:** The layout automatically conceals sensitive fields and transaction records when the user enters the task-switching menu, protecting privacy from bystanders.
* **Local Vault Cues:** Using solid, flat, grounding grayscale backgrounds (`bankyar.semantic.color.background`) and clear key markers, reminding the user that they are in an encrypted on-device environment.

---

## 3. UX Principles

### User Experience Philosophy
Every interaction must respect the user’s cognitive, emotional, and physical boundaries. We reject "delight" when it conflicts with utility. The user experience is optimized for fast extraction of facts and immediate task execution. We treat user attention as a finite, precious asset that must never be squandered.

### Design Principles Matrix

The following matrix defines the priority weight and design governance rules for the primary dimensions of the BankYar design system:

| Design Dimension | Primary Objective | Trade-off Decision Rule | Priority Weight | Governance Status |
| :--- | :--- | :--- | :---: | :---: |
| **Information Accessibility** | Clear visual readability and proper screen reader labeling. | Accessibility ALWAYS takes priority over decorative layouts. | **Highest** | Mandatory |
| **Privacy / Security** | Protecting sensitive financial details from local exposure. | Local security controls ALWAYS take priority over convenience. | **High** | Mandatory |
| **Interface Simplicity** | Low cognitive load and minimal decorative noise. | Clean structural utility ALWAYS takes priority over creative layouts. | **High** | Mandatory |
| **Interaction Speed** | Fast task execution and minimal interaction cost. | Performance perception ALWAYS takes priority over slow animations. | **Medium** | Mandatory |

### Design Laws

Every screen, feature, and interaction layout in BankYar must strictly comply with these design laws:

1. **One Primary Goal Per Screen:** Every layout must focus on a single core task, displaying only relevant controls.
2. **Information Before Decoration:** Visual embellishments, decorative illustrations, and complex icons are prohibited.
3. **Maximum Two Primary Actions:** Screens must not present more than two primary buttons, reducing choice anxiety.
4. **Recognition Over Recall:** Actions, categories, and tags must be displayed clearly, ensuring users do not have to memorize previous steps.
5. **No Surprise Behaviors:** Standard elements (buttons, fields, lists) must function predictably.
6. **Low Interaction Cost:** Common tasks (such as assigning a category or adding a note) must be achievable in two taps or fewer.
7. **Privacy by Default:** Sensitive financial details must be concealed on launch until the user unlocks the app.
8. **RTL Native Alignment:** Persian layouts must be built RTL-first, ensuring natural reading and scrolling patterns.

### UX Decision Matrix

Use this matrix to resolve design conflicts during feature planning:

| Conflict Scenario | Option A (Exciting/Decorative) | Option B (Simple/Utility) | Resolution Decision Rule |
| :--- | :--- | :--- | :--- |
| **Visualizing Categories** | Colorful 3D pie charts with detailed gradients. | Flat structural donut charts with text percentages. | **Option B.** Flat structural charts preserve readability, reducing visual clutter and rendering overhead. |
| **Assigning Categories** | Multi-gesture drag-and-drop interaction. | Stable bottom sheet with large, clickable category chips. | **Option B.** Clicking category chips has a lower interaction cost and is easier to perform one-handed. |
| **Presenting Data** | Complex visual dashboards with multiple indicators. | Clean, structured vertical lists. | **Option B.** Structured vertical lists reduce cognitive load, making financial records easier to scan. |

### Information Density Strategy & Cognitive Load Reduction Strategy
To prevent cognitive overload and maintain spatial balance on screens of any density:
* **Information Chunking:** Adjacent data fields are grouped into logical, semantic cards (such as Origin, Transaction Details, and Category Rules).
* **Consistent Visual Grid:** Layout structures align to a strict structural grid, enabling users to scan different screens using identical eye movements.
* **Progressive Disclosure Strategy:** High-level lists display only core facts (Amount, Date, and Merchant). Detailed parameters (such as raw SMS text or system parsing rules) are hidden behind a single-tap transaction inspector.
* **Contrast-Based Hierarchy:** Information is arranged strictly by transactional significance:
  1. **The Number:** The financial amount of the transaction, representing the highest visual emphasis.
  2. **The Counterparty:** The merchant or financial sender.
  3. **The Date & Time:** The timestamp of the transaction.
  4. **The Meta-tags:** Categories, custom notes, and hashtags.

### Touch Experience & Mobile-first Principles
Interactive visual components must have custom constant structures and follow strict touch guidelines:
* **Tappable Comfort:** All interactive touch targets are large and well-spaced (minimum forty-eight units on Android), preventing accidental triggers.
* **Symmetrical Padding:** Layouts maintain consistent padding values to shield interactive regions from screen borders.
* **System-Native Feedback:** Interaction confirmations leverage system haptics and native sheet transitions to feel familiar and immediate.

### One-Hand Usage Philosophy & One-Hand Usage Strategy
Operating a device on the move requires an optimal layout structure that places controls directly within the user's natural range of reach:
* **Interaction Zone Split:** Actionable controls and interactive elements reside in the lower half of the viewport, while reading content and static charts reside in the top half.
* **Predictable Bottom Sheets:** Configuration settings and categorization flows expand as stable bottom sheets, bringing controls directly to the user's thumb.
* **No Side Gestures:** Horizontal swipes are reserved strictly for high-level tab switches, ensuring users do not accidentally trigger destructive actions (like deletions) while scrolling.

### Thumb Zone Optimization
Following ergonomics, the viewport is split into three functional zones:
* **Natural Reach Zone (Bottom third):** Reserved for primary navigation tabs, quick category chips, search triggers, and action buttons.
* **Stretch Zone (Middle third):** Used for interactive list items, secondary filters, and select text fields.
* **Hard Reach Zone (Top third):** Reserved for non-interactive analytical readouts, cash flow balances, and structural headers.

---

## 4. Interaction Philosophy

### Navigation Experience & Navigation Philosophy
The navigation architecture is linear, simple, and flat to reduce cognitive search paths:
* **Flat Linear Hierarchy:** Primary screens are accessible via a persistent bottom navigation bar. Deep nesting is prohibited, with sub-pages limited to a maximum depth of one layer.
* **Immediate Context Return:** Sub-pages (such as rule editors) exist only one layer deep, returning users immediately to the parent context.
* **Standard Back Actions:** The system back button or swipe gesture always returns the user to their immediate previous screen.

### Motion Experience & Motion Philosophy
Animations are strictly prohibited if they are merely decorative. Transitions and animations are used only to communicate structural relationships between screens (such as expanding a card into a details page) or confirm a system status change. All motions utilize linear eases and fast durations (typically under two hundred units) to maintain high-speed rendering and prevent lag.

### Micro-interaction Philosophy & Feedback Philosophy
Every interaction must confirm its state instantly:
* **Tactile Affirmation:** Activating a control triggers a subtle, instant haptic vibration and surface contrast adjustment.
* **Sub-100-Unit Timelines:** Interactive controls render their updated states immediately on-screen before verifying database confirmation, keeping the interface feeling instantaneous.
* **Self-Dismissing Overlays:** Success states (such as a saved rule or database backup) use calm visual overlays that dismiss themselves automatically, returning the user to their active task with zero extra taps.

### Animation Principles
All animations must comply with three core principles:
1. **Immediate Response:** Transition feedback must trigger immediately upon user touch.
2. **Linear Ease Control:** Animations use clean, standard, or decelerated curves to ensure transitions start immediately and settle smoothly.
3. **Spatial Logic Preservation:** Components must expand and move from their literal physical touch origins, preserving spatial continuity.

### Delight Moments
While we reject decorative animations, we introduce subtle, functional moments of delight:
* **The Parsing Ingestion Event:** When a new banking SMS is received and parsed successfully in the background, a subtle, linear progress indicator transitions smoothly to a success state on the ledger, quietly confirming background ingestion.
* **Perfect Balance Match:** When the derived balance from parsed SMS data perfectly matches the confirmed bank statement balance, a clean badge updates with a soft, stable green checkmark, signaling precision.

---

## 5. Visual Strategy

### Visual Philosophy
The interface is a canvas for financial data. Layout boundaries, grouping containers, and reading lines are defined by the structure of the text and figures themselves. Decorative embellishments (like complex icons or heavy backgrounds) are strictly avoided.

### Financial Data Visualization Strategy & Financial Dashboard Philosophy
* **Flat Donut Charts:** Financial categories and analytical ratios use flat donut charts with clean text percentages, preserving readability and avoiding visual clutter.
* **Consistent Visual Scales:** Bar charts and sparklines use identical height limits and a single accent color scale to display monthly spending trends objectively.
* **Mathematical Rigor:** Financial numbers are never truncated, rounded, or visually obscured unless explicitly collapsed by the user for privacy.

### Card-based Experience & Card Language
Cards are the primary visual container in BankYar, used to group adjacent transactional metadata:
* **Absolute Flatness:** Cards sit flat on the base canvas background, defined by subtle borders instead of heavy shadows.
* **Inner Structural Margins:** Maintain consistent internal spacing around content to ensure card boundaries do not squeeze typography.
* **Clean Typographic Layout:** Organize data hierarchically: place financial amounts at the visual start edge, with merchant names and timestamps aligned logically.

### Search Experience & Search-first Navigation
Finding specific transactions is immediate:
* **Instant Inline Results:** Results populate immediately as the user types, highlighting matching strings in bold text.
* **Predictable Clears:** A simple close button allows the user to clear the search query with a single tap, resetting the view immediately.
* **Clean Spacing:** Results align perfectly with the standard vertical ledger rhythm, maintaining design consistency.

### Filtering Experience & Filter Navigation
* **Horizontal Chip Sliders:** Filters are arranged as horizontal chip sliders, positioned directly above the transaction feed for easy reach.
* **Clear Active States:** Active filters use high-contrast outlines and a small checkmark icon to signal their state.
* **Reset All Trigger:** An explicit "Reset All" button is displayed whenever filters are active, allowing users to clear all filters with a single tap.

### Dark Theme Experience & Dark Theme Strategy
The Dark Theme optimizes visual comfort in low-light environments, protecting users during night-time analytical reviews:
* **Deep Grayscale Base:** The background uses deep neutral grays (`bankyar.global.color.gray.alpha`) rather than pure black, minimizing eye strain and preventing pixel smearing.
* **Accessible Contrast:** Contrast ratios are verified to ensure body text and functional accents remain readable against dark backgrounds.
* **Elevation via Opacity:** Standard shadows are ineffective against dark backgrounds. Elevation is instead communicated by applying soft white opacity overlays to container surfaces.

### Light Theme Experience & Light Theme Strategy
The Light Theme provides clean, high-contrast readability under bright lighting conditions (such as direct sunlight):
* **Pure Neutral Canvas:** The background uses light gray scales, maintaining a clean, spacious layout.
* **Crisp Card Boundaries:** Cards are defined by thin, medium-contrast borders, keeping layouts flat and tidy.
* **Highly Legible Typography:** Text uses deep neutral grays, providing maximum typographic contrast.

### Privacy Experience & Privacy-first Design Principles
To protect sensitive financial information from local exposure:
* **Local Confidentiality by Default:** No sensitive financial information or transaction lists are visible on the dashboard without unlocking the app first.
* **Window Redaction:** The layout remains blank or heavily blurred inside the operating system's task switcher card to prevent visual leaks.
* **Input Privacy:** Forms do not pre-fill or cache financial details outside of the encrypted local database environment.

---

## 6. Experience Strategy

### Empty State Experience & Empty State Philosophy
* **Actionable Guidance:** Empty screens (such as a ledger with no transactions or a rules list with no entries) never present blank voids. Instead, they provide brief, reassuring context and a clear primary action to get started.
* **Clear Reassurance:** On initial launch, empty states explain why there is no data and guide the user on granting permissions or manually importing their statement.
* **Abstract Visual Anchor:** Place a flat, monochromatic icon at the vertical center of the container to ground the layout.

### Loading Experience & Loading Experience Philosophy
* **Instant Structured Layouts:** Feeds load instantly using stable structural layouts (skeletons), preventing awkward jumps as content renders.
* **No Spinner Blocks:** Avoid full-screen loading spinner blocks; instead, allow the user to navigate and inspect the UI freely while background tasks run.
* **Linear Progress Indicators:** For multi-step tasks (such as importing CSV histories), a thin linear progress bar displays deterministic progress clearly.

### Error Recovery Experience & Error Prevention Philosophy
* **Destructive Confirmation:** Destructive actions (such as purging databases or deleting templates) require explicit, secondary confirmations (such as entering a PIN or confirming a prompt).
* **Validation Prior to Save:** Text entry fields, regex patterns, and CSV statements are validated in real-time, preventing invalid inputs from entering the database.
* **Graceful Parsing Fallback:** If parsing fails, the message is saved as an unparsed item rather than failing silently, allowing manual correction.
* **Supportive Recovery Messaging:** Error messages must use plain, non-technical Persian text, explaining the issue and providing clear recovery steps.

### Notification Experience
* **No Promotional Alerts:** The app never sends marketing notifications, behavior reminders, or promotional alerts.
* **Transactional Integrity:** Notifications are reserved strictly for real-time background SMS parsing, confirming background ingestion quietly and securely.
* **Quiet Channels:** System notifications are configured as quiet channels by default, preventing unnecessary audio interruptions.

---

## 7. Accessibility Strategy

### Accessibility Experience & Accessibility Philosophy
* **Color Independence:** Meaning is never conveyed solely by color (e.g., green for income and red for expense). Layouts use clear signs, text labels, and structural shapes (such as plus/minus symbols or descriptive badges) alongside color.
* **Robust Contrast:** Text, icons, and focus indicators maintain strong, legible contrast ratios under all lighting conditions, meeting strict WCAG AA standards.
* **Screen Reader Integrity:** Every interactive layout and data element is labeled with semantic descriptions for screen readers.
* **Dynamic Scale Protection:** Text background containers must expand dynamically, preventing text from overlapping or clipping when system-level text magnification is increased.

### Native Persian (RTL) Layout System & RTL-first Design Principles
* **Mirrored Flow Direction:** Layouts flow from right to left (RTL) for Persian. Chronological feeds, reading paths, and swipe gestures are mirrored naturally.
* **Persian Font Adaptation:** Typographic layouts are designed specifically around the baseline and line-height requirements of Persian fonts, using custom vertical spacing boundaries.
* **Icon Mirroring:** Directional icons (such as back arrows, progress indicators, and text fields) are mirrored dynamically based on the active locale.

---

## 8. Future Evolution

### Future Scalability & Future Evolution Strategy
* **Scale via Layout Consistency:** As features expand, they must be integrated into our existing screen structures. For example, local Wi-Fi sync controls are located within the Settings page, maintaining our flat navigation hierarchy.
* **Component-First Expansion:** New features must compose existing layout patterns (such as standard bottom sheets and flat cards) rather than introducing custom layouts.
* **Unified Token Suffixes:** All future theme expansions must use our standard naming taxonomy, ensuring long-term consistency.
* **Decoupled Theme Schemas:** Theme definitions are stored as platform-agnostic schemas. Component layouts query logical tokens, which resolve their physical values based on the active theme, supporting future iOS and cross-platform builds.

---

## 9. Quality Checklist & Governance

### Review Checklist

Before releasing any screen, layout, or feature, verify compliance against this checklist:

- [ ] Does the screen focus on a single, clear primary goal?
- [ ] Is all sensitive financial information concealed on launch?
- [ ] Are all Persian text layouts aligned RTL-first?
- [ ] Do interactive elements avoid complex gestures, relying on clear clicks instead?
- [ ] Are all decorative gradients, 3D elements, and unnecessary animations excluded?
- [ ] Does the screen maintain clear visual contrast and accessibility labeling?
- [ ] Does the layout rely 100% on active design tokens, with zero hardcoded values?
- [ ] Are all sensitive balances and transaction details masked when the app transitions to the background task switcher?
- [ ] Do all text elements meet WCAG AA contrast standards against their background?
- [ ] Is meaning conveyed through text labels, badges, or shapes, rather than relying solely on color shifts?
- [ ] Are all layout boundaries and vertical lists stacked using standard spacing tokens?

### Anti-pattern Catalog

The following visual and interaction anti-patterns are strictly prohibited:

* **Overloaded Dashboards:** Do not crowd multiple widgets, charts, and summaries onto a single screen.
* **Heavy Gradients & Neumorphism:** Avoid deep 3D-styled cards, heavy shadows, and glowing gradients.
* **Unnecessary Animations:** Decorative spin transitions, complex loading shapes, and slow slide transitions are prohibited.
* **Hidden Actions:** Primary actions (such as saving, editing, or deleting) must not be concealed behind non-standard gestures (like long-pressing or double-tapping).
* **Multiple Floating Buttons:** Do not place multiple floating actions on a single screen.
* **Color-Only Indicators:** Relying exclusively on green or red color shifts to convey credit/debit operations, without adding math symbols or badges.
* **Un-Masked Previews:** Leaving sensitive card details and balances visible when the app transitions to the background multitasking task-switcher menu.

### Governance Rules

* **Design Consistency Priority:** Long-term design consistency takes precedence over visual novelty. Every screen must utilize our standard, flat layout patterns.
* **Explainable Visual Decisions:** Every design choice (such as adding a visual cue or placing a control) must be justified based on usability, accessibility, or privacy benefits.
* **Compliance Checks:** All new features must pass the official Design Review Checklist before implementation.
* **Mandatory Token Usage:** Every color, spacing margin, border, corner curve, and typography style must reference an active design token. Hardcoded visual values are prohibited.
* **One Purpose Per Token:** A semantic token must serve exactly one purpose. Reusing semantic tokens for secondary meanings is prohibited.

### Trade-off Analysis

1. **Absolute Privacy vs. Cloud Convenience:**
   - *The Trade-off:* Eliminating cloud-sync requires users to manually export and import backup files.
   - *Rationale:* User trust is our highest priority. Verifiable, 100% offline local storage protects user privacy, which outweighs the convenience of automated cloud sync.
2. **Minimal Animations vs. Interface Delight:**
   - *The Trade-off:* The app avoids slow, playful transitions, resulting in a sober, serious interface.
   - *Rationale:* BankYar is a precise financial tool, not an entertainment app. Silent, ultra-fast performance reduces user anxiety and accelerates task execution.

### Architecture Alignment

This design philosophy is aligned with the **BankYar Architecture Baseline v1.0**:
* **Thread Separation:** The UI thread remains responsive (60fps+) by running intensive tasks (like processing statements or executing backups) in separate background processes.
* **Zero Network Manifest:** No design element relies on external assets, fonts, or remote trackers, ensuring perfect offline operation.
* **Secure Cache Erasure:** Sensitive details are purged from temporary layouts immediately after the application is sent to the background, preventing visual exposure.
