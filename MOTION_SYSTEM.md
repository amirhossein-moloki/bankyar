# BankYar Motion & Animation System (v1.0.0)
## Enterprise-Grade Motion Architecture Specification for Offline-First Secure Financial Applications

---

## Executive Summary
This document establishes the official **Motion & Animation System Architecture** for BankYar. Designed to implement the core product personality (Stoic, Precise, Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this specification acts as the single source of truth for all transitions, interactive animations, and motion boundaries within the application.

In strict alignment with BankYar’s **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets:
* **No visual animations** are designed for mere decoration.
* **No Lottie or GIF files** are created or bundled.
* **No hardcoded durations** are allowed.
* **No numerical easing curves** are permitted in component styles.
* **No physical dimensions** are declared.
* **No framework-specific code** or class definitions are generated.

Every motion behavior defined herein is abstracted to semantic motion tokens, logical directional rules, and accessibility-first constraints. This architecture ensures absolute consistency across light and dark modes, native RTL Persian layouts, variable pixel densities, accessibility high-contrast regimes, and guarantees high-performance execution on low-end Android hardware and future iOS/cross-platform environments.

---

## TABLE OF CONTENTS
1. [Motion Philosophy](#1-motion-philosophy)
2. [Motion Principles](#2-motion-principles)
3. [Animation Hierarchy](#3-animation-hierarchy)
4. [Motion Categories](#4-motion-categories)
5. [Screen Transition Strategy](#5-screen-transition-strategy)
6. [Navigation Animation Rules](#6-navigation-animation-rules)
7. [Dialog Animation Rules](#7-dialog-animation-rules)
8. [Bottom Sheet Animation Rules](#8-bottom-sheet-animation-rules)
9. [Snackbar Animation Rules](#9-snackbar-animation-rules)
10. [Notification Animation Rules](#10-notification-animation-rules)
11. [FAB Motion Rules](#11-fab-motion-rules)
12. [Card Interaction Motion](#12-card-interaction-motion)
13. [List Animation Rules](#13-list-animation-rules)
14. [Search Animation Rules](#14-search-animation-rules)
15. [Filter Animation Rules](#15-filter-animation-rules)
16. [Expand / Collapse Rules](#16-expand--collapse-rules)
17. [Loading Motion](#17-loading-motion)
18. [Progress Motion](#18-progress-motion)
19. [Success Feedback Motion](#19-success-feedback-motion)
20. [Error Feedback Motion](#20-error-feedback-motion)
21. [Empty State Motion](#21-empty-state-motion)
22. [Gesture Feedback](#22-gesture-feedback)
23. [Press States](#23-press-states)
24. [Hover States](#24-hover-states)
25. [Focus States](#25-focus-states)
26. [Scroll Behavior](#26-scroll-behavior)
27. [Refresh Behavior](#27-refresh-behavior)
28. [Drag & Drop Guidelines](#28-drag--drop-guidelines)
29. [Motion Token Mapping](#29-motion-token-mapping)
30. [Performance Budget](#30-performance-budget)
31. [Accessibility Strategy](#31-accessibility-strategy)
32. [Reduced Motion Strategy](#32-reduced-motion-strategy)
33. [Dark Mode Considerations](#33-dark-mode-considerations)
34. [Haptic Feedback Strategy](#34-haptic-feedback-strategy)
35. [Governance Rules](#35-governance-rules)
36. [Validation Rules](#36-validation-rules)
37. [Anti-pattern Catalog](#37-anti-pattern-catalog)
38. [Motion Review Checklist](#38-motion-review-checklist)
39. [Migration Strategy](#39-migration-strategy)
40. [Future Evolution Strategy](#40-future-evolution-strategy)

---

## 1. Motion Philosophy
The Motion Philosophy of BankYar is built on the core product identity: **Stoic, Precise, and Empowering**. In a secure, offline-first financial application managing sensitive transactional balances, motion is never an aesthetic decoration or a mechanism for gamification. It is a vital user-experience element used to communicate state, explain change, and reduce uncertainty.

Every transition, press feedback, and state mutation must respect the user's cognitive boundaries and physical task-execution speed. Motion exists strictly to support:
* **Mathematical Truth:** Highlighting financial numerical accuracy.
* **Instant Ingestion:** Confirming state mutations within strict performance limits.
* **Spatial Relationship:** Explaining visual hierarchy as elements scale or expand.
* **Accessibility Integrity:** Offering equal visual comfort across diverse text magnifications and motion sensitivity regimes.

We reject decorative loops, bouncy elastic scales, playful animations, or slow transitions that delay the user’s primary tasks.

---

## 2. Motion Principles
The execution of any animation sequence must conform to eight fundamental Motion Principles:
1. **Purposeful Motion:** Every motion sequence must have a clear structural or state-based reason to exist. It must guide the user's focus, indicate the start/end of a transition, or verify an interactive selection. If an animation is purely decorative, it must be removed.
2. **Natural Movement:** Easing curves must feel calm, structured, and professional. There are no dramatic bounces, spring-elastic parameters, or excessive screen shaking. Easing curves mimic physical properties (such as controlled friction and inertia) but maintain absolute deceleration boundaries to ensure zero overshoot.
3. **Spatial Continuity:** Sibling and hierarchical layers must transition logically within the layout grid. A card cannot fade into existence arbitrarily; it must scale from its boundary or slide along a logical axis. Spatial direction must mirror perfectly when switching between Persian RTL and English LTR layouts.
4. **Reduced Cognitive Load:** Limiting active elements to a single focus node. Unaffected items remain completely static. Simultaneous competing animations are strictly prohibited to prevent visual clutter and confusion.
5. **Performance First:** Animations must execute flawlessly at maximum frame rates, utilizing GPU-accelerated layers (such as transforms and opacity transitions) while completely avoiding layout recalculations or repaints.
6. **Accessibility:** Motion is optional. The system respects device settings (such as Reduced Motion toggles and Android animation scale overrides) and adapts transitions to prevent visual distress or vestibular triggers.
7. **Consistency:** Interaction signatures, timing curves, and haptic feedback profiles are shared globally across all interactive elements, creating a predictable and cohesive user experience.
8. **Trustworthy Financial UX:** Reliable, calm, and high-precision visual and haptic verification profiles confirm sensitive transactions, assuring the user that their offline local database is secure and accurate.

---

## 3. Animation Hierarchy
To prevent simultaneous, competing animations from overwhelming the user’s attention, BankYar implements a strict three-tier **Animation Hierarchy**:

### Motion Hierarchy Diagram
```
+-----------------------------------------------------------+
|                   Tier 1: Global Context                  |
| (Page transitions, scrim fade-ins, modal entries)          |
+-----------------------------------------------------------+
                             |
                             v
+-----------------------------------------------------------+
|                  Tier 2: Structural Layers                |
| (Bottom sheets, dialog expansions, card expansions)       |
+-----------------------------------------------------------+
                             |
                             v
+-----------------------------------------------------------+
|               Tier 3: Component & Inline                  |
| (Press states, check indicators, switch toggles)          |
+-----------------------------------------------------------+
```

### Hierarchy Rules:
* **Concurrency Protection:** No Tier 1 transition may run concurrently with a Tier 2 expansion. Component animations inside a container must remain static until the container's structural movement completes.
* **Focus Anchoring:** A Tier 3 animation must only occur at the immediate coordinate of user contact, keeping peripheral elements completely stable.
* **Sequential Execution:** Multiple parent-child layout transformations must sequence their entry times smoothly using structured stagger delay tokens.

---

## 4. Motion Categories
All system motions are classified under a structured **Animation Taxonomy**, ensuring developers use the correct tokens and duration bounds:

### Animation Taxonomy Diagram
```
                      BankYar Animation Taxonomy
                                  |
         +------------------------+------------------------+
         |                                                 |
  Structural Transitions                            Interactive Feedback
  - Screen Transitions                              - Hover & Touch Pressed
  - Modal Entries (Sheets/Dialogs)                  - Selection & Check states
  - Expand / Collapse Blocks                        - Inline Loading Skeletons
```

1. **Structural Transitions:** Transitions that modify the spatial structure of the screen, such as moving between views, opening modal sheets, or expanding cards.
2. **Interactive Feedback:** Localized visual changes that confirm a direct touch or selection, such as pressing a button, toggling a switch, or updating a checklist.

---

## 5. Screen Transition Strategy
Screen transitions govern how the user moves between the primary application views (Ledger, Analytics, Rules, Diagnostics, Settings) with strict adherence to parent-to-child, child-to-parent, and sibling-to-sibling layout relationships.

### Transition Paths:
* **Splash → Onboarding:** The splash brand elements fade out smoothly while scaling down slightly using the fast duration token and standard curve. Simultaneously, the onboarding introduction text and layout components fade in and scale up from a compressed scale to baseline.
* **Onboarding → Dashboard:** Utilizing a sibling horizontal transition, the onboarding screen translates out toward the logical end edge while the dashboard home screen slides in from the logical start edge, accompanied by an opacity fade.
* **Dashboard → Transaction Details:** This path utilizes a high-fidelity container transform. The selected ledger card expanding boundary morphs smoothly in both directions to fill the entire screen, maintaining text reading line alignment throughout the transition.
* **Dashboard → Statistics:** Sibling cross-fade with logical lateral shift. The statistics screen shifts into place along the horizontal axis, reflecting peer navigation.
* **Dashboard → Search:** The search input bar scales horizontally to cover the top area, while secondary elements fade out and the list viewport slides down.
* **Dashboard → Settings:** A lateral transition that translates settings menus smoothly from the logical start to logical end.
* **Security Center:** Parent-to-child vertical translate from the bottom screen boundary, accompanied by a subtle elevation surface depth shift.
* **Backup Center:** Elevated bottom-sheet transition sliding up vertically from the bottom safe area limit.
* **Dialogs:** Symmetrical scale expansion starting from the screen center coordinates, paired with a backdrop dimming fade.
* **Bottom Sheets:** Vertical slide-up transition from the bottom edge of the layout, tracking drag gestures.
* **Navigation Drawer (Future):** Horizontal slide transition from the logical start edge of the layout, overlaying the main surface with an ambient scrim.

### RTL-First Directionality:
All horizontal translations are logical. In Persian RTL, navigating forward to a peer section translates content from logical start to logical end.

---

## 6. Navigation Animation Rules
Navigation animations control how lateral tab bars, drawer menus, and top app bars update when the active route changes.

### Architectural Rules:
* **Bottom Navigation Highlights:** When a user taps a bottom navigation icon, the inactive outline style switches to a filled style. The active colored background pill expands horizontally from the icon's mathematical center using a smooth, linear opacity fade.
* **Navigation Rail:** Designed for tablet devices, the active rail item highlights its selected state using a vertical translation or fill interpolation, reflecting the physical layout.
* **Future Navigation Drawer:** Slips smoothly from the logical start boundary using the decelerate curve token, resting with an ambient drop shadow overlay.
* **App Bar Transitions:** Page titles must transition smoothly when navigation occurs. The old title fades out while translating slightly vertically, and the new title fades in from the opposite vertical offset, maintaining visual stability.

---

## 7. Dialog Animation Rules
Dialogs represent high-priority system alerts (such as PIN confirmations or database purge notices) that overlay the entire screen canvas.

```
                   Dialog Modal Entry Flow
  +-------------------------------------------------------+
  | [Base Canvas Scrim Fades In: bankyar.motion.curve.linear]|
  |                                                       |
  |      +-----------------------------------------+      |
  |      | [Dialog Scales Up: motion.curve.decelerate]|   |
  |      +-----------------------------------------+      |
  +-------------------------------------------------------+
```

### Architectural Rules:
* **Background Scrim:** The background overlay scrim fades in with a flat opacity transition, using the linear curve token `bankyar.motion.curve.linear` and a translucent opacity value.
* **Container Entry:** The dialog container scales up slightly (from a compressed scale factor to its final base dimensions), using the decelerate curve token `bankyar.motion.curve.decelerate`. It must never bounce or overshoot.
* **Container Exit:** When dismissed, the dialog container fades out quickly while scaling down slightly, using the accelerate curve token `bankyar.motion.curve.accelerate`.
* **Touch Boundary Safety:** Tap events outside the dialog bounds will trigger a subtle horizontal shake animation if the dialog requires an explicit action, indicating that a choice must be made.

---

## 8. Bottom Sheet Animation Rules
Bottom sheets are interactive drawer menus that expand from the bottom edge of the screen, bringing settings and transaction categorization tools directly within comfortable reach.

### Architectural Rules:
* **Slide Entry:** The sheet container slides up vertically from the bottom screen edge, using the decelerate curve token `bankyar.motion.curve.decelerate`.
* **Slide Exit:** When dismissed, the sheet slides down vertically, exiting the screen area rapidly using the accelerate curve token `bankyar.motion.curve.accelerate`.
* **Gesture Dismissal Tracking:** If the user drags the sheet downwards, the sheet container must track their touch coordinates with perfect 1:1 spatial mapping.
* **Throw Velocity Snap:** Upon release, if the dragging speed exceeds the system threshold, the sheet exits completely. If the velocity is low, it snaps back smoothly to its resting point.

---

## 9. Snackbar Animation Rules
Snackbars provide brief, self-dismissing confirmations (such as "Custom note saved") at the bottom of the screen.

### Architectural Rules:
* **Entry Path:** Snackbars slide up vertically from below the bottom safe area boundary, using the decelerate curve token `bankyar.motion.curve.decelerate` and resting above the bottom navigation bar.
* **Layout Shifts:** When a snackbar enters, any active Floating Action Button (FAB) translates vertically upward to avoid overlapping interactive targets.
* **Exit Path:** After its self-dismissal duration completes, the snackbar fades out while translating slightly downwards, avoiding abrupt visual cuts.

---

## 10. Notification Animation Rules
Notification animations govern how real-time, background SMS capture confirmations or security alerts render in the system notification tray.

### Architectural Rules:
* **Low Visual Impact:** Banners translate downwards from the top screen margin using the standard decelerate curve.
* **Zero Loop Animations:** Notification icons must remain completely static. Glowing, flashing, or pulsing animations are prohibited to prevent visual distraction.
* **Dismissal Behavior:** Swipe gestures slide the notification horizontally off the screen canvas, matching the system-native behavior with 1:1 touch coordinate mapping.

---

## 11. FAB Motion Rules
Floating Action Buttons (FABs) provide rapid access to the primary screen action (such as manual SMS parsing or custom template creation).

### Architectural Rules:
* **Scale Transitions:** When scrolling down a dense ledger feed, the FAB must scale down to zero using the accelerate curve to maximize reading surface area. When scrolling stops, the FAB scales back up to its standard dimensions using the decelerate curve.
* **Icon Rotations:** When a FAB triggers an expandable speed-dial list, the central plus icon rotates clockwise to form a close cross symbol (×). The rotation must use a smooth, standard curve with zero overshoot.
* **Speed-Dial Stagger:** The child quick-action items expand sequentially from the FAB boundary, utilizing the stagger delay token to establish a clean visual flow.

---

## 12. Card Interaction Motion
Cards represent the primary visual vessel for financial records in BankYar.

### Architectural Rules:
* **Pressed Compression:** When pressed, cards compress slightly inward (scaling down by a minor scale factor) to confirm the touch event instantly.
* **Elevation Shifts:** Upon selection or touch, the ambient surface shadow changes its depth range to simulate a physical lift.
* **Details Expansion:** When tapped to show transaction details, the card does not open a new screen. Instead, the card container expands vertically on the active canvas, using the standard curve token `bankyar.motion.curve.standard` to reveal hidden metadata rows while adjacent cards translate downwards.

---

## 13. List Animation Rules
List animations control how new items (such as parsed banking SMS entries) are rendered in scrollable ledger feeds.

### Architectural Rules:
* **Insert:** Newly parsed entries slide into the top of the ledger vertically while fading in. If multiple items are added, they must animate sequentially with a minor staggered offset, preventing jarring layout jumps.
* **Remove:** Swiping to delete an entry slides the item horizontally along the scroll track, matching the user's touch movement with 1:1 precision. The empty slot then collapses vertically as adjacent items translate smoothly to fill the gap.
* **Reorder:** Active items selected for reordering elevate vertically, casting a soft ambient shadow. Adjacent items translate vertically to open a space, providing real-time feedback during the drag.
* **Refresh:** A manual refresh operation animates a progress loader, translating vertically before scaling down smoothly once the feed is updated.
* **Pagination:** When reaching the bottom of the list, a subtle shimmer loader fades in, expanding the list container vertically without interrupting the scroll momentum.
* **Swipe to Delete:** Swiping past the activation boundary triggers a rapid horizontal exit, blending the background fill color to the error status red.
* **Swipe to Archive:** Swiping in the opposite logical direction transitions the background container to a secondary status tint.
* **Expansion / Collapse:** Detailed transaction rows expand vertically using a clip-mask path, maintaining layout stability.

---

## 14. Search Animation Rules
Search animations coordinate search input expansion, clear-button states, and list updates during text entry.

### Architectural Rules:
* **Input Expansion:** Tapping the search icon expands the search bar horizontally to fill the screen margin boundary, while secondary page titles fade out smoothly.
* **Instant Clear Feedback:** The clear cross button (×) fades in instantly when characters are typed. When tapped, the search term is erased, and the button fades out immediately.
* **Live Result Updates:** As search inputs change, list results fade and translate slightly vertically to reveal the filtered set, keeping the transition light.

---

## 15. Filter Animation Rules
Filter animations handle chip selections, filter panel drawers, and category tag updates.

### Architectural Rules:
* **Chip State Transitions:** Tapping a filter chip (e.g., selecting a specific bank filter) transitions its background fill from neutral to the active color. The transition is a smooth, linear blend.
* **Panel Drawer entries:** The filtering drawer slides horizontally from the logical start edge of the layout, matching the reading direction of the active locale.
* **Tag Accumulation:** Newly added filter tags scale up from their center coordinates sequentially, keeping focus on the active filters.

---

## 16. Expand / Collapse Rules
Expand and collapse motions handle accordions, sub-menus, and detailed transaction inspect blocks.

### Architectural Rules:
* **Vertical Growth:** Collapsed content areas expand vertically, pushing lower content cards downwards smoothly. Using hard visual cuts or clipping masks without layout interpolation is prohibited.
* **Chevron Indication:** Beside the expandable title, a disclosure chevron icon rotates smoothly to indicate the expanded state.
* **Clipping Boundary:** Content rendering inside the expanding container must clip to the animated height boundary, preventing text elements from overlapping.

---

## 17. Loading Motion
Loading motions indicate background task processing, such as database ingestion, backup exports, or optimization logs.

### Architectural Rules:
* **Skeleton Shimmer Fades:** Full-screen spinning wheels are prohibited. Feeds must use flat skeleton UI elements. Skeleton shapes must animate with a soft, pulsing opacity transition, using the linear curve token `bankyar.motion.curve.linear`.
* **Linear Continuity:** The opacity transition must repeat smoothly without sudden visual breaks, establishing a quiet, non-distracting loading state.
* **Staggered Sweep:** Multiple shimmer cells sweep their gradient highlights sequentially, creating an elegant progress flow.

---

## 18. Progress Motion
Progress motions track multi-step long-running background tasks, such as file restorations or template compilation.

### Architectural Rules:
* **Continuous Interpolation:** Progress bars must animate their filled region smoothly. When the progress percentage updates, the bar must transition to the new width using a decelerate curve, preventing jerky increments.
* **Circular Progress Ring:** Applied in small containers, the progress ring path expands its arc smoothly, maintaining velocity control.
* **State Transition:** Upon reaching maximum progress, the bar fades out smoothly, transitioning into the success feedback screen.

---

## 19. Success Feedback Motion
Success feedback confirms positive system events, such as successful database backups, verified PIN creation, or successful transaction template matches.

### Architectural Rules:
* **Subtle Confirmed State:** Success states utilize a quiet, non-playful animation. A circular checkmark badge scales up slightly while its internal path draws in smoothly, using the decelerate curve token `bankyar.motion.curve.decelerate`.
* **Automatic Dismissal:** The success view must dismiss itself automatically after a brief, stable duration, returning the user to their active task with zero extra taps.
* **Path Stroke Drawing:** The checkmark outline uses a path-stroke animation, drawing from start to finish to confirm the state change.

---

## 20. Error Feedback Motion
Error feedback highlights critical failures that require user attention, such as PIN mismatch lockouts, SQLCipher database corruption, or invalid import formats.

### Architectural Rules:
* **Anxiety-Free Shakes:** In input forms (such as PIN entry), a validation error triggers a subtle, horizontal shake animation. The shake moves horizontally along a tight axis, using a linear curve before returning to its center. No vertical bouncing is allowed.
* **Visual Isolation:** The error banner fades in vertically above the form input field, drawing immediate focus to the validation message.
* **Transition Alert:** The container transitions its border color to the semantic error status color instantly, providing clear feedback.

---

## 21. Empty State Motion
Empty states appear when screens contain no transaction, rule, or log records.

### Architectural Rules:
* **Fading Entry:** When a screen resolves to an empty state, the empty state illustration and its descriptive copy fade in smoothly.
* **Call to Action Scale:** The primary get-started action button scales up slightly from its center, drawing the user's focus to their next step.
* **Slight Translation:** Elements translate slightly along the vertical axis during entry to establish vertical rhythm.

---

## 22. Gesture Feedback
Gesture feedback controls how the interface reacts to user touch inputs, swipes, and drags.

### Architectural Rules:
* **Perfect 1:1 Tracking:** Interactive elements that track user dragging (such as bottom sheets or swipe-to-delete cards) must update their spatial coordinates with perfect 1:1 alignment with the user's touch input.
* **Velocity-Based Completion:** When a gesture is released, the system calculates the release velocity. If the velocity exceeds a threshold, the transition completes automatically; otherwise, the element slides smoothly back to its default state.
* **Damping and Resistance:** As gestures approach layout margins, visual feedback applies friction to indicate edge boundaries.

---

## 23. Press States
Press states provide immediate visual and haptic confirmation when an interactive element (such as a button, card, or menu item) is tapped.

### Interaction Flow Chart
```
  [User Touch Pressed Event]
              |
              v
  [1. Trigger Physical Haptic Tap (bankyar.haptic.tap.light)]
  [2. Scale Container Inward: bankyar.motion.curve.standard]
  [3. Fade Pressed Tint Layer: bankyar.motion.curve.linear]
              |
              v
  [Touch Released / Completed]
              |
              v
  [1. Scale Container Back to Base Dimensions]
  [2. Fade Out Pressed Tint Layer]
```

### Architectural Rules:
* **Immediate Reaction:** Touch press states must render within fast response limits to feel instantaneous.
* **Proportionate Scaling:** Clickable items compress slightly inward, scaling down by a minor factor to simulate physical depth.
* **State Recovery:** If a touch is dragged away from the element boundary, the scale expands back to default, cancelling the pending action.

---

## 24. Hover States
Hover states provide immediate visual feedback on desktop or pointer devices when a cursor hovers over interactive elements.

### Architectural Rules:
* **Instant Contrast Shifts:** When hovered, the component background transitions to a slightly darker or lighter tint (shifting by +1 step on the semantic color scale).
* **Cursor Selection:** The pointer cursor must switch to an interactive hand indicator, signaling that the element is clickable.
* **Elevation Adjustment:** Small containers (such as analytics cards) elevate slightly during hover, indicating interactive focus.

---

## 25. Focus States
Focus states are a critical accessibility requirement, helping users navigate the interface using external keyboards, screen readers, or switch controls.

### Architectural Rules:
* **Focus Outline Ring:** Focused elements must render a clear, high-contrast outline indicator using the focused border token. The outline fades in instantly to draw immediate focus.
* **No Layout Shifting:** The focus ring must overlay the component boundaries without altering its padding or size, preventing layout shifts.
* **Color Contrast:** The focus indicator uses high-contrast colors to ensure maximum visibility against dark or light canvases.

---

## 26. Scroll Behavior
Scroll behaviors manage how feeds, lists, and charts transition vertically or horizontally during swipe gestures.

### Architectural Rules:
* **Natural Inertia Decay:** Scrolling lists must utilize standard system-native physics and deceleration decay, keeping scrolling feeling natural and responsive.
* **Overscroll Clamping:** Scroll containers must clamp smoothly when reaching list boundaries. Glowing or bouncy overscroll effects are prohibited.
* **Sliver Transitions:** Top headers shrink smoothly into compact app bar states as scrolling proceeds, keeping title elements legible.

---

## 27. Refresh Behavior
Refresh behaviors handle manual list updates, such as manually checking for new SMS entries in the transaction feed.

### Architectural Rules:
* **Pull-to-Refresh Gesture:** Pulling down on the scroll feed reveals a centered progress circle that rotates smoothly, tracking the user's drag distance with 1:1 precision.
* **Ingestion State:** When released, the indicator continues rotating with a linear curve while the system processes updates. Upon completion, the ledger feed updates smoothly, and the indicator fades out.

---

## 28. Drag & Drop Guidelines
Drag and drop guidelines govern how elements (such as ordering custom template matching rules) are moved manually.

### Architectural Rules:
* **Visual Lift:** When grabbed, the item scales up slightly and increases its elevation, casting a soft ambient shadow to indicate that it is detached from the list surface.
* **Logical Reordering:** As the item is dragged vertically, adjacent cards translate downwards or upwards smoothly to make space, ensuring the reordering process is predictable.
* **Drop Confirmation:** Dropping an item in a new position resets its elevation and scale with standard easing, accompanied by a light haptic confirmation.

---

## 29. Motion Token Mapping
This system links design tokens to semantic animation parameters, separating visual timing from layout and component code:

### Duration Tokens:
* `bankyar.motion.duration.instant`: Used for color swaps, active state focus rings, and text entries.
* `bankyar.motion.duration.fast`: Used for button touch pressed compressions and hover feedback.
* `bankyar.motion.duration.medium`: Used for modal bottom sheet entries, dialog animations, and sliding drawers.
* `bankyar.motion.duration.slow`: Used for large parent container transforms and onboarding transitions.

### Delay Tokens:
* `bankyar.motion.delay.none`: Immediate execution without offset.
* `bankyar.motion.delay.short`: Minor offset for quick sequential layouts.
* `bankyar.motion.delay.stagger`: Standard spacing offset for vertical list rendering.

### Curve Tokens:
* `bankyar.motion.curve.linear`: Absolute flat motion, reserved for opacity fades and skeleton loading shimmers.
* `bankyar.motion.curve.standard`: Natural easing curve, used for expanding card details and list rearrangements.
* `bankyar.motion.curve.decelerate`: Fast entry curve, used to bring elements onto the screen rapidly.
* `bankyar.motion.curve.accelerate`: Exit acceleration curve, used to move departing elements off the screen rapidly.
* `bankyar.motion.curve.spring_damped`: Critically damped curve for touch tracking overshoot recovery, ensuring zero oscillation.

### Parameter Scales:
* `bankyar.motion.scale.compress`: Pressed container scale reduction factor.
* `bankyar.motion.scale.expand`: Expansion container scale growth factor.
* `bankyar.motion.opacity.hidden`: Zero opacity transparency.
* `bankyar.motion.opacity.visible`: Full opacity reading contrast.

---

## 30. Performance Budget
To ensure BankYar remains lightweight, responsive, and battery-efficient on low-end Android hardware, all animations must adhere to a strict **Performance Budget**:

### Performance Guidelines:
* **60 FPS Minimum Guarantee:** Scroll feeds, list transitions, and interactive buttons must maintain a minimum rendering speed of sixty frames per second.
* **120 FPS Native Support:** Devices with high refresh rate displays (such as flagship Android and iOS devices) must render transitions at one hundred and twenty frames per second.
* **GPU Overdraw Prevention:** Complex animations must avoid overlapping semi-transparent layers. Background surfaces must remain flat to prevent GPU overdraw.
* **No Layout Recalculations:** Animations must only modify transform and opacity properties. Modifying spatial dimensions (such as width, height, or padding) during animation is prohibited, as it forces expensive layout recalculations.
* **Graceful Interruption:** If a user initiates a new transition while an animation is running, the active animation must terminate immediately and transition to the new state without causing UI stuttering.

---

## 31. Accessibility Strategy
The accessibility strategy ensures that the application remains usable and comfortable for all users, including those with visual impairments or motion sensitivities.

### Accessibility Checklist:
* **Contrast Integrity:** Text elements inside animated components must maintain high contrast ratios against their backgrounds under all lighting conditions.
* **Reduced Motion Support:** The system must detect when the user has enabled "Reduce Motion" in their system settings, immediately switching animations to instant durations.
* **Screen Reader Support:** Screen readers must read the final, resolved state of animated components immediately, avoiding reading intermediate transition states.
* **Dynamic Text Scaling:** Animated cards and forms must scale vertically to support up to two hundred percent text magnification without clipping text.
* **Focus Order Alignment:** Focus transitions match visual reading direction, avoiding random spatial jumps during layout shifts.

---

## 32. Reduced Motion Strategy
Reduced Motion settings protect users who experience discomfort or motion sickness from animations.

### Architectural Rules:
* **Instant State Switches:** When "Reduce Motion" is enabled in system settings, all motion durations are immediately set to `bankyar.motion.duration.instant`.
* **Transitions Override:** Sliding sheets and scaling dialogs switch to simple opacity fade-ins, ensuring the interface remains completely flat and static.
* **Alternative Animations:** Complex structural transforms default to instant opacity cross-fades, avoiding all spatial translating and scaling.

---

## 33. Dark Mode Considerations
Dark Mode considerations optimize visual transitions for low-light environments, protecting eye health during night-time reviews.

### Architectural Rules:
* **No High-Contrast Flashes:** Opacity transitions must be carefully balanced to prevent sudden flashes of light when opening modals against deep gray canvases.
* **Elevation via Opacity:** Instead of heavy shadows, elevation changes in dark mode are communicated by applying soft white opacity overlays to container surfaces.
* **Phosphor Ghosting Mitigation:** Easing curves and timings are optimized to reduce visual smearing on OLED screens during fast scrolling.

---

## 34. Haptic Feedback Strategy
Haptic feedback provides tactile confirmations that work alongside visual animations, enhancing physical comfort and utility.

### Architectural Rules:
* **Light Tap Confirmation:** Tapping buttons, filter chips, or settings toggles triggers a short, light haptic vibration.
* **Medium Alert Confirmation:** Saving a custom note, completing a database backup, or confirming a template triggers a distinct, medium haptic vibration.
* **Heavy Warning Confirmation:** Destructive actions, validation errors, or PIN mismatches trigger a sequence of sharp haptic vibrations, warning the user of the state.
* **System-Native Sync:** Physical feedback profiles synchronize with visual animations to reinforce the sense of physical depth.

---

## 35. Governance Rules
Governance rules protect the design system from inconsistent additions, visual clutter, and unnecessary animations.

### Governance Rules Matrix:
1. **Mandatory Token Usage:** Every animation, timing, and curve must reference an active design token. Hardcoded visual values are strictly prohibited.
2. **No Decorative Animations:** Animations must only be used to communicate structure, focus, or system status. Purely decorative movements are prohibited.
3. **Graceful Interruptions:** All animations must support instant interruption or cancellation, returning control to the user immediately.
4. **Reduced Motion Compliance:** Every new animation must support reduced motion settings, switching to instant transitions automatically.
5. **Approval Required:** Any addition of new curves or transition patterns to the system requires approval from the Design System Governance Board.

---

## 36. Validation Rules
The design system compiler validates all motion definitions against a strict rule set before deployment:

### Validation Matrix:
| Rule ID | Check Target | Validation Condition | Failure Penalty |
| :--- | :--- | :--- | :--- |
| **VAL-MOT-01** | Raw Numbers | Motion files must not contain raw millisecond durations | Build Failure |
| **VAL-MOT-02** | Bezier Curves | Motion files must not contain raw cubic bezier coordinates | Build Failure |
| **VAL-MOT-03** | Token Reference | Every transition must map to an active motion token | Build Failure |
| **VAL-MOT-04** | GPU Overdraw | Animated layers must avoid nested opacity modifiers | Compile Warning |
| **VAL-MOT-05** | Mirroring | Horizontal translations must use logical start/end coordinates | Build Failure |

---

## 37. Anti-pattern Catalog
The following visual, architectural, and motion anti-patterns are strictly prohibited:

* **Hardcoded Timing Parameters:** Specifying raw numerical durations or cubic easing coordinates directly in layout styles instead of referencing active design tokens.
* **Bouncy Elastic Scales:** Using dramatic spring animations, elastic bounces, or heavy physical overshoots, which break our professional tone.
* **Uninterruptible Transitions:** Locking user inputs during transitions, forcing the user to wait for animations to complete before interacting.
* **Horizontal Gestures for Deletion:** Triggering destructive actions (such as card deletion) with horizontal swipes without an explicit secondary confirmation.
* **Competing Animations:** Animating multiple independent elements simultaneously on a single screen, which increases cognitive load and causes UI stuttering.

---

## 38. Motion Review Checklist
Before releasing any screen, transition, or interactive element, verify compliance against this checklist:

- [ ] Does the animation reference a semantic motion token, avoiding hardcoded values?
- [ ] Is the animation strictly functional, avoiding pure decoration?
- [ ] Does the animation complete within our performance budget, maintaining 60 FPS?
- [ ] Does the transition support instant interruption, returning control to the user?
- [ ] Does the element support Reduced Motion settings, switching to instant transitions?
- [ ] Does the motion align with our Persian RTL-first directionality?
- [ ] Is the transition paired with comfortable haptic feedback?

---

## 39. Migration Strategy
To transition the existing codebase to the structured Motion & Animation System, developers follow a phased migration plan:

```
+------------------+     +------------------+     +------------------+
| 1. Audit & Map   | --> | 2. Asset Cleanup | --> | 3. Refactor UI   |
| (Identify raw    |     | (Replace custom  |     | (Apply motion    |
| timings in code) |     | bezier curves)   |     | tokens globally) |
+------------------+     +------------------+     +------------------+
```

1. **Audit & Map (Phase 1):** Identify and map all raw animation durations, cubic curves, and transitions in the codebase, establishing corresponding tokens in the design dictionary.
2. **Asset Cleanup (Phase 2):** Replace custom curves and raw timings with standard system tokens, ensuring uniform transitions across all features.
3. **Refactor UI (Phase 3):** Apply motion tokens and haptic feedback configurations across all UI components, and run performance diagnostics to verify 60 FPS rendering.

---

## 40. Future Evolution Strategy
As BankYar expands, the Motion & Animation System is built to scale:
* **AI Assistant:** Future AI parsing assistants will use dynamic line progress and organic pulsing shimmers that scale up smoothly to represent deep parsing cycles, ensuring the transition from raw text is legible.
* **Voice Interaction:** Speech capture states will use localized indicator waves translating outwards from the search bar center, matching the amplitude.
* **Wear OS:** Spacing and duration tokens scale to match compact circular screen limits, adapting transitions to shorter pathways.
* **Foldables:** Transitions handle dual-screen fold splits dynamically, translating content containers to separate screen halves during detail expansions without breaking spatial continuity.
* **Desktop:** Pointer coordinates determine hover scaling effects, adapting components to standard cursor selections.
* **Multi-window:** Layout structures scale dynamically when resizing screen boundaries, transitioning components from expanded columns to single-column feeds smoothly.

---
**End of Document**
