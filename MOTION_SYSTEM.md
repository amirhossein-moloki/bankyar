# BankYar Motion & Interaction Design Specification (v2.0.0)
## Enterprise-Grade Interaction & Motion Architecture for Offline-First Secure Financial Applications

---

## 1. Executive Summary

This document establishes the official **Motion & Interaction Design Specification** for BankYar. Designed to implement the core product personality (Stoic, Precise, and Empowering) and UX principles defined in `DESIGN_PHILOSOPHY.md`, this specification acts as the single source of truth for all transitions, interactive animations, and motion boundaries within the application.

In strict alignment with BankYar’s **Offline-First**, **Privacy-First**, and **Accessibility-First** tenets:
* **No visual animations** are designed for mere decoration.
* **No Lottie or GIF files** are created or bundled.
* **No hardcoded durations** are allowed in layout definitions.
* **No numerical easing curves** are permitted in component styles.
* **No physical dimensions** or hex colors are declared.
* **No framework-specific code** or class definitions are generated.

Every motion behavior defined herein is abstracted to semantic motion tokens, logical directional rules, and accessibility-first constraints. This architecture ensures absolute consistency across light and dark modes, native RTL Persian layouts, variable pixel densities, accessibility high-contrast regimes, and guarantees high-performance execution on low-end Android hardware and future iOS/cross-platform environments.

---

## 2. Interaction Philosophy

### Overall Interaction Principles
The BankYar interaction philosophy is built upon the concept of a high-precision, silent, and highly reliable physical instrument. Every touch, drag, and transition must respect the user's cognitive limits, offering a quiet, non-distracting environment for sensitive financial monitoring.

### Touch-First Experience
In an offline-first financial environment, physical interactions must feel direct and responsive. Touch targets are generous and follow a strict spatial structure:
* **Generous Targets:** All interactive components maintain safety margins around touch areas to prevent accidental triggers.
* **Symmetrical Interaction Margins:** Interactive bounds align symmetrically with the layout grid, offering a highly predictable feel.

### One-Handed Interaction Strategy
To ensure comfortable one-handed operation on modern tall mobile devices, BankYar implements a strict split-level layout architecture:
* **Reading Zone:** The upper portion of the screen is dedicated to information display, charts, and reading lines.
* **Action Zone:** The lower half of the screen houses all primary interactive elements, tab switches, and key input targets.
* **Comfort Zones:** Key interactions avoid the extreme upper corners, ensuring that every everyday action is reachable without straining the hand.

### Thumb-Zone Optimization
The primary navigation bar, floating actions, primary confirm buttons, and form-level inputs are positioned within the natural sweeping arc of the thumb:
* **Bottom-Anchored Operations:** Bottom sheets, dialog controls, and filter configurations are drawn upward from the bottom margin to place critical buttons within the direct comfort area of the thumb.
* **Lateral Balance:** Dual actions are distributed horizontally across the bottom safe zone to balance touch effort.

### Predictability
Every interface component must act consistently across different contexts:
* **Consistent Behavior:** Tapping a card must always perform the same expansion or open the same details panel. Swipes must never execute different actions on sibling screens.
* **Familiar Triggers:** Interactive targets use standard visual structures (such as elevated surfaces and highlighted borders) to signal clickability.

### Error Prevention
Interaction flows are designed to intercept and prevent user mistakes before they alter the local encrypted database:
* **Destructive Confirmations:** High-risk tasks (such as purging ledger entries or clearing system templates) require an explicit secondary confirmation.
* **Real-time Boundary Validations:** Text inputs and mathematical configurations validate entries on-the-fly, displaying clean visual indications instead of failing silently on save.

### Immediate Feedback
Every valid touch input must be acknowledged instantly:
* **Visual Acknowledgment:** Components transition to their pressed or focused state within immediate response limits.
* **Tactile Synchronization:** Visual state changes are paired with light haptic pulses to confirm the physical contact.

### Cognitive Load Reduction
We respect the user's attention. To minimize mental overhead, the interface strips away all non-essential visual elements:
* **Minimal Interventions:** The application remains silent in the background, only displaying essential alerts or parsed SMS receipts.
* **Focal Primacy:** At any moment, only one primary element is allowed to animate or expand, keeping the user's eye locked to a single, clear point of focus.

---

## 3. Motion Philosophy

### Motion Philosophy
Motion in BankYar exists strictly as a functional UX mechanism, never as an aesthetic decoration. In a secure, offline-first personal finance application managing sensitive transactional balances, animation is used to communicate system state, explain spatial relationships, and reduce visual uncertainty. We reject bouncy elastic scales, playful loops, or slow transitions that delay task execution.

### Motion Principles
Every animation sequence must conform to these eight core principles:
1. **Functional Necessity:** Animations must have a clear, structural, or state-based reason to exist. If a transition is purely decorative, it is removed.
2. **Precision and Deceleration:** Easing curves feel calm and controlled. They mimic natural friction but maintain absolute deceleration bounds to ensure zero overshoot or bounce.
3. **Spatial Continuity:** Sibling and hierarchical layers must transition logically within the layout grid. Spatial direction must mirror perfectly when switching between Persian RTL and English LTR layouts.
4. **Reduced Cognitive Load:** Limit active transitions to a single focus node. Unaffected items remain completely static.
5. **GPU Acceleration:** Animations must execute flawlessly at maximum frame rates, utilizing hardware-accelerated transform and opacity layers.
6. **Accessibility Options:** All transitions adapt seamlessly to device-level settings, supporting reduced motion and high-contrast accessibility overrides.
7. **Predictable Interaction Signatures:** Timing curves, haptic feedback profiles, and pressed states are shared globally across all interactive elements.
8. **Trustworthy Financial UX:** Calm and precise visual verifications confirm sensitive operations, assuring the user that their data is handled securely.

### Animation Hierarchy
To prevent simultaneous, competing animations from overwhelming the user’s attention, BankYar implements a three-tier motion hierarchy:
* **Tier 1 (Global Context):** Page transitions, scrim fades, and high-level view translations that establish overall context.
* **Tier 2 (Structural Layers):** Bottom sheets, dialog expansions, and card-level container transforms that update the spatial layout of the active screen.
* **Tier 3 (Component & Inline):** Localized press feedback, switch toggles, checkbox markers, and linear progress updates.
* **Concurrency Rule:** A Tier 1 transition must never run concurrently with a Tier 2 or Tier 3 animation. Sub-components remain static until parent transitions are fully complete.

### Motion Categories
System motions are divided into two clear categories:
1. **Structural Transitions:** Scale, slide, and fade animations that morph layout containers during navigation, modal entries, or detail expansions.
2. **Interactive Feedback:** Quick, localized visual and tactile updates that acknowledge direct user actions, such as touch pressed states, hover highlights, and selection checkmarks.

---

## 4. Animation Standards

This section establishes standard parameters for duration, delay, easing curves, and visual transforms:

* **Duration Standards:**
  * **Instant:** Used for immediate color swaps, active state focus rings, and text entry updates.
  * **Fast:** Used for button touch pressed compressions, hover feedback, and selection checkmarks.
  * **Medium:** Used for modal bottom sheet entries, dialog animations, and sliding drawers.
  * **Slow:** Used for large parent container transforms and onboarding screen transitions.
* **Delay Standards:**
  * **None:** Immediate execution without offset.
  * **Short:** Minor offset for quick sequential layouts.
  * **Stagger:** Standard spacing offset for vertical list rendering.
* **Curves and Easing:**
  * **Linear:** Flat motion, reserved for opacity fades and skeleton loading shimmers.
  * **Standard:** Natural easing curve, used for expanding card details and list rearrangements.
  * **Decelerate:** Fast entry curve, used to bring elements onto the screen rapidly.
  * **Accelerate:** Exit acceleration curve, used to move departing elements off the screen rapidly.
  * **Spring Damped:** Critically damped curve for touch tracking overshoot recovery, ensuring zero oscillation.
* **Fade Transitions:** Opacity updates transition smoothly between hidden and visible states, maintaining reading legibility throughout the transition.
* **Scale Transitions:** Elements compress or expand slightly during interaction, referencing precise scale tokens to represent visual depth.
* **Slide Transitions:** Components translate along logical layout axes, ensuring smooth entry and exit paths.
* **Shared Element Transitions:** Container transforms morph container boundaries smoothly between high-level list items and detailed transaction inspectors.
* **Expansion & Collapse:** Vertical height transitions utilize precise height mapping to push or pull adjacent cards smoothly without layout jumps.
* **Hero Transitions:** Large brand or core data points translate and scale between primary layouts, maintaining spatial continuity.

### Motion Token Mapping
All animation parameters are governed by semantic motion tokens, ensuring consistency across light and dark modes, RTL Persian layouts, and variable device densities:
* `bankyar.motion.duration.instant`
* `bankyar.motion.duration.fast`
* `bankyar.motion.duration.medium`
* `bankyar.motion.duration.slow`
* `bankyar.motion.delay.none`
* `bankyar.motion.delay.short`
* `bankyar.motion.delay.stagger`
* `bankyar.motion.curve.linear`
* `bankyar.motion.curve.standard`
* `bankyar.motion.curve.decelerate`
* `bankyar.motion.curve.accelerate`
* `bankyar.motion.curve.spring_damped`
* `bankyar.motion.scale.compress`
* `bankyar.motion.scale.expand`
* `bankyar.motion.opacity.hidden`
* `bankyar.motion.opacity.visible`

---

## 5. Navigation Motion

### Screen Transition Strategy
Screen transitions govern how the user moves between primary application views, maintaining parent-to-child and sibling-to-sibling spatial relationships. Under Persian RTL, horizontal translations are logical:
* **Splash to Onboarding:** Brand elements fade out while scaling down slightly. Onboarding introduction layouts fade in and scale up from a compressed state.
* **Onboarding to Dashboard:** A horizontal slide transition. Onboarding slides out toward the logical end margin, while the dashboard slides in from the logical start margin, accompanied by a soft cross-fade.
* **Dashboard to Transaction Details:** High-fidelity container transform. The selected ledger card morphs smoothly in both directions to fill the screen canvas, keeping text reading lines aligned.
* **Dashboard to Statistics:** Sibling cross-fade with logical lateral shift, reflecting horizontal peer navigation.
* **Dashboard to Search:** The search input bar scales horizontally to cover the top safe area, while adjacent page titles fade out.
* **Dashboard to Settings:** Sibling lateral transition translating settings menus smoothly from logical start to logical end.

### Navigation Animation Rules
Navigation animations control lateral tab highlights and top app bar updates:
* **Bottom Navigation Highlights:** Tapping a navigation icon switches the active state. The active colored background pill expands horizontally from the icon's center using a smooth, linear opacity fade.
* **App Bar Transitions:** Top app bar titles transition smoothly. The old title fades out while translating slightly vertically, and the new title fades in from the opposite vertical offset.
* **Navigation Rail:** On tablet devices, active rail items highlight their selection using a vertical translation, reflecting the physical layout.

### Dialog Animation Rules
Dialogs represent high-priority alert alerts (such as PIN confirmations or database purge notices) that overlay the screen canvas:
* **Background Scrim:** The background overlay scrim fades in with a flat opacity transition, using the linear curve token `bankyar.motion.curve.linear`.
* **Container Entry:** The dialog container scales up slightly (from a compressed scale factor to its final dimensions) using the decelerate curve token `bankyar.motion.curve.decelerate`, with zero overshoot.
* **Container Exit:** When dismissed, the dialog container fades out quickly while scaling down slightly, using the accelerate curve token `bankyar.motion.curve.accelerate`.
* **Dismissal Alerts:** Tap events outside dialog bounds trigger a subtle horizontal shake animation if the dialog requires an explicit action.

### Bottom Sheet Animation Rules
Bottom sheets are interactive panels that expand from the bottom edge of the screen:
* **Slide Entry:** The sheet container slides up vertically from the bottom screen edge, using the decelerate curve token `bankyar.motion.curve.decelerate`.
* **Slide Exit:** When dismissed, the sheet slides down vertically, exiting the screen area rapidly using the accelerate curve token `bankyar.motion.curve.accelerate`.
* **Gesture Tracking:** If the user drags the sheet downwards, the container tracks their touch coordinates with perfect 1:1 spatial mapping.
* **Snap Back:** Upon release, if dragging velocity is low, the sheet snaps back smoothly to its resting height. If velocity exceeds the system threshold, the sheet exits completely.

### Snackbar Animation Rules
Snackbars provide brief, self-dismissing confirmations at the bottom of the screen:
* **Entry Path:** Snackbars slide up vertically from below the bottom safe area boundary, using the decelerate curve token `bankyar.motion.curve.decelerate` and resting above the bottom navigation bar.
* **Layout Shifts:** When a snackbar enters, any active Floating Action Button (FAB) translates vertically upward to avoid overlapping interactive targets.
* **Exit Path:** After its self-dismissal duration completes, the snackbar fades out while translating slightly downwards, avoiding abrupt visual cuts.

### Notification Animation Rules
Notification animations govern how background SMS capture confirmations or security alerts render in the system notification tray:
* **Low Visual Impact:** Banners translate downwards from the top screen margin using the standard decelerate curve.
* **Zero Loop Animations:** Notification icons must remain completely static. Glowing, flashing, or pulsing animations are prohibited to prevent visual distraction.
* **Dismissal Behavior:** Swipe gestures slide the notification horizontally off the screen canvas, matching the system-native behavior with 1:1 touch coordinate mapping.

---

## 6. Component Behaviors

### FAB Motion Rules
Floating Action Buttons (FABs) provide rapid access to the primary screen action (such as manual SMS parsing or custom template creation):
* **Scale Transitions:** When scrolling down a dense ledger feed, the FAB must scale down to zero using the accelerate curve to maximize reading surface area. When scrolling stops, the FAB scales back up to its standard dimensions using the decelerate curve.
* **Icon Rotations:** When a FAB triggers an expandable speed-dial list, the central plus icon rotates clockwise to form a close cross symbol (×). The rotation must use a smooth, standard curve with zero overshoot.
* **Speed-Dial Stagger:** The child quick-action items expand sequentially from the FAB boundary, utilizing the stagger delay token to establish a clean visual flow.

### Card Interaction Motion
Cards represent the primary visual vessel for financial records in BankYar:
* **Pressed Compression:** When pressed, cards compress slightly inward (scaling down by a minor scale factor) to confirm the touch event instantly.
* **Elevation Shifts:** Upon selection or touch, the ambient surface shadow changes its depth range to simulate a physical lift.
* **Details Expansion:** When tapped to show transaction details, the card does not open a new screen. Instead, the card container expands vertically on the active canvas, using the standard curve token `bankyar.motion.curve.standard` to reveal hidden metadata rows while adjacent cards translate downwards.

### List Animation Rules
List animations control how new items (such as parsed banking SMS entries) are rendered in scrollable ledger feeds:
* **Insert:** Newly parsed entries slide into the top of the ledger vertically while fading in. If multiple items are added, they must animate sequentially with a minor staggered offset, preventing jarring layout jumps.
* **Remove:** Swiping to delete an entry slides the item horizontally along the scroll track, matching the user's touch movement with 1:1 precision. The empty slot then collapses vertically as adjacent items translate smoothly to fill the gap.
* **Reorder:** Active items selected for reordering elevate vertically, casting a soft ambient shadow. Adjacent items translate vertically to open a space, providing real-time feedback during the drag.
* **Refresh:** A manual refresh operation animates a progress loader, translating vertically before scaling down smoothly once the feed is updated.
* **Pagination:** When reaching the bottom of the list, a subtle shimmer loader fades in, expanding the list container vertically without interrupting the scroll momentum.
* **Swipe to Delete:** Swiping past the activation boundary triggers a rapid horizontal exit, blending the background fill color to the error status red.
* **Swipe to Archive:** Swiping in the opposite logical direction transitions the background container to a secondary status tint.
* **Expansion / Collapse:** Detailed transaction rows expand vertically using a clip-mask path, maintaining layout stability.

### Search Animation Rules
Search animations coordinate search input expansion, clear-button states, and list updates during text entry:
* **Input Expansion:** Tapping the search icon expands the search bar horizontally to fill the screen margin boundary, while secondary page titles fade out smoothly.
* **Instant Clear Feedback:** The clear cross button (×) fades in instantly when characters are typed. When tapped, the search term is erased, and the button fades out immediately.
* **Live Result Updates:** As search inputs change, list results fade and translate slightly vertically to reveal the filtered set, keeping the transition light.

### Filter Animation Rules
Filter animations handle chip selections, filter panel drawers, and category tag updates:
* **Chip State Transitions:** Tapping a filter chip (e.g., selecting a specific bank filter) transitions its background fill from neutral to the active color. The transition is a smooth, linear blend.
* **Panel Drawer entries:** The filtering drawer slides horizontally from the logical start edge of the layout, matching the reading direction of the active locale.
* **Tag Accumulation:** Newly added filter tags scale up from their center coordinates sequentially, keeping focus on the active filters.

### Expand / Collapse Rules
Expand and collapse motions handle accordions, sub-menus, and detailed transaction inspect blocks:
* **Vertical Growth:** Collapsed content areas expand vertically, pushing lower content cards downwards smoothly. Using hard visual cuts or clipping masks without layout interpolation is prohibited.
* **Chevron Indication:** Beside the expandable title, a disclosure chevron icon rotates smoothly to indicate the expanded state.
* **Clipping Boundary:** Content rendering inside the expanding container must clip to the animated height boundary, preventing text elements from overlapping.

---

## 7. Gesture System

### Gesture Feedback
Gestures are the primary interface between the user's physical hand and the digital layout. Feedback must feel highly responsive:
* **Immediate Response:** Every valid gesture (tap, double tap, long press, swipe, drag) triggers an immediate visual or haptic acknowledgment.
* **Damping and Resistance:** When a gesture reaches layout boundaries, visual indicators apply friction, signaling limits.

### Scroll Behavior
Scroll behaviors manage how feeds, lists, and charts transition vertically or horizontally during swipe gestures:
* **Natural Inertia Decay:** Scrolling lists must utilize standard system physics and deceleration decay, keeping scrolling feeling natural and responsive.
* **Overscroll Clamping:** Scroll containers clamp smoothly when reaching list boundaries. Glowing or bouncy overscroll effects are prohibited.
* **Sliver Transitions:** Top headers shrink smoothly into compact app bar states as scrolling proceeds, keeping title elements legible.

### Refresh Behavior
Refresh behaviors handle manual list updates, such as manually checking for new SMS entries in the transaction feed:
* **Pull-to-Refresh Gesture:** Pulling down on the scroll feed reveals a centered progress circle that rotates smoothly, tracking the user's drag distance with 1:1 precision.
* **Ingestion State:** When released, the indicator continues rotating with a linear curve while the system processes updates. Upon completion, the ledger feed updates smoothly, and the indicator fades out.

### Drag & Drop Guidelines
Drag and drop guidelines govern how elements (such as ordering custom template matching rules) are moved manually:
* **Visual Lift:** When grabbed, the item scales up slightly and increases its elevation, casting a soft ambient shadow to indicate that it is detached from the list surface.
* **Logical Reordering:** As the item is dragged vertically, adjacent cards translate downwards or upwards smoothly to make space, ensuring the reordering process is predictable.
* **Drop Confirmation:** Dropping an item in a new position resets its elevation and scale with standard easing, accompanied by a light haptic confirmation.

### Gesture Definitions and Conflicts
To prevent accidental triggers and ensure highly predictable scrolling:
* **Tap:** Simple direct touch. Triggers immediate visual press feedback and executes the target action on release.
* **Double Tap:** Prohibited for primary actions. Reserved strictly for contextual secondary zoom or reset actions.
* **Long Press:** Triggers a medium haptic pulse and opens high-level management context menus. Long presses must never be the only path to perform an action.
* **Swipe:** Lateral movement along a horizontal path. Used to transition between primary tabs or dismiss alerts.
* **Drag:** High-precision touch tracking. Used to slide bottom sheets or scroll content viewports.
* **Dismiss:** Swipe-to-dismiss transitions use lateral slide-out paths with linear opacity fades.
* **Horizontal Scroll:** Multi-card analytics feeds and chip categories scroll horizontally, with subtle edge fades signaling extra content.
* **Vertical Scroll:** The ledger feed scrolls vertically, maintaining smooth scrolling frame rates.
* **Gesture Conflict Resolution:** Vertical scrolling takes strict precedence over lateral swiping. When a vertical drag is detected, horizontal swipe recognition is temporarily locked until the drag ends, preventing accidental tab switching.

---

## 8. Feedback System

### Press States
Press states provide immediate visual and haptic confirmation when an interactive element is tapped:
* **Immediate Reaction:** Touch press states must render within fast response limits to feel instantaneous.
* **Proportionate Scaling:** Clickable items compress slightly inward, scaling down by a minor factor to simulate physical depth.
* **State Recovery:** If a touch is dragged away from the element boundary, the scale expands back to default, cancelling the pending action.

### Hover States
Hover states provide immediate visual feedback on desktop or pointer devices when a cursor hovers over interactive elements:
* **Instant Contrast Shifts:** When hovered, the component background transitions to a slightly darker or lighter tint (shifting by +1 step on the semantic color scale).
* **Cursor Selection:** The pointer cursor must switch to an interactive hand indicator, signaling that the element is clickable.
* **Elevation Adjustment:** Small containers (such as analytics cards) elevate slightly during hover, indicating interactive focus.

### Focus States
Focus states are a critical accessibility requirement, helping users navigate the interface using external keyboards, screen readers, or switch controls:
* **Focus Outline Ring:** Focused elements must render a clear, high-contrast outline indicator using the focused border token. The outline fades in instantly to draw immediate focus.
* **No Layout Shifting:** The focus ring must overlay the component boundaries without altering its padding or size, preventing layout shifts.
* **Color Contrast:** The focus indicator uses high-contrast colors to ensure maximum visibility against dark or light canvases.

### Haptic Feedback Strategy
Haptic feedback provides tactile confirmations that work alongside visual animations, enhancing physical comfort and utility:
* **Light Tap Confirmation:** Tapping buttons, filter chips, or settings toggles triggers a short, light haptic vibration.
* **Medium Alert Confirmation:** Saving a custom note, completing a database backup, or confirming a template triggers a distinct, medium haptic vibration.
* **Heavy Warning Confirmation:** Destructive actions, validation errors, or PIN mismatches trigger a sequence of sharp haptic vibrations, warning the user of the state.
* **System-Native Sync:** Physical feedback profiles synchronize with visual animations to reinforce the sense of physical depth.

### Component Feedback States
The system provides clear feedback for all component states:
* **Disabled State:** Disabled elements transition to a low-opacity state, with all hover, press, and drag interactions locked.
* **Loading State:** Components replace their text labels with a small centered progress loader, maintaining layout width and height.
* **Success State:** Transitions to the semantic success status color, accompanied by a light checkmark illustration.
* **Failure State:** Triggers form-level shake feedback and displays a clear error boundary.
* **Warning State:** Applies a subtle orange border outline and displays a non-intrusive warning alert.
* **Offline State:** Not applicable as BankYar is 100% offline-by-design. The app operates at full capability without network connectivity.
* **Permission Required:** Blocked views display a static, clear empty state illustration detailing how to enable settings.

---

## 9. Loading & Empty States

### Loading Motion
Loading motions indicate background task processing, such as database ingestion, backup exports, or optimization logs:
* **Skeleton Shimmer Fades:** Full-screen spinning wheels are prohibited. Feeds must use flat skeleton UI elements. Skeleton shapes must animate with a soft, pulsing opacity transition, using the linear curve token `bankyar.motion.curve.linear`.
* **Linear Continuity:** The opacity transition must repeat smoothly without sudden visual breaks, establishing a quiet, non-distracting loading state.
* **Staggered Sweep:** Multiple shimmer cells sweep their gradient highlights sequentially, creating an elegant progress flow.

### Progress Motion
Progress motions track multi-step long-running background tasks, such as file restorations or template compilation:
* **Continuous Interpolation:** Progress bars must animate their filled region smoothly. When the progress percentage updates, the bar must transition to the new width using a decelerate curve, preventing jerky increments.
* **Circular Progress Ring:** Applied in small containers, the progress ring path expands its arc smoothly, maintaining velocity control.
* **State Transition:** Upon reaching maximum progress, the bar fades out smoothly, transitioning into the success feedback screen.
* **Background Processing:** Background operations display a discrete progress ring in the top status bar, allowing the user to navigate the active feed.
* **Import Progress:** Importing large statement blocks displays an overlay card with a linear progress bar and a counting percentage tag.
* **Backup Progress:** Exporters animate a circular loader that fades out instantly once the encrypted archive is written to local storage.
* **Search Progress:** Live searches show a subtle shimmer at the top of the result feed, avoiding jarring layout shifts.
* **Statistics Calculation:** Re-aggregating spending segments displays a fade transition over affected chart containers, rendering the updated analytics once resolved.

### Empty State Motion
Empty states appear when screens contain no transaction, rule, or log records:
* **Fading Entry:** When a screen resolves to an empty state, the empty state illustration and its descriptive copy fade in smoothly.
* **Call to Action Scale:** The primary get-started action button scales up slightly from its center, drawing the user's focus to their next step.
* **Slight Translation:** Elements translate slightly along the vertical axis during entry to establish vertical rhythm.
* **No Transactions:** Ledger views display a clean, static illustration with an explicit button to import statements.
* **No Search Results:** Search voids show a zero-results graphic with a recommendation to refine search keywords.
* **No Statistics:** Analytics sections show a flat, empty card explaining that spending records are required to render cash-flow segments.
* **Permission Missing:** Permission panels render a static safety lock illustration with a direct link to Android system settings.
* **No Backup:** Backup panels display an alert state with a primary button to create an initial encrypted backup.
* **First Launch:** On initial startup, the setup flow uses sequential card fades to guide the user through database encryption setup.

---

## 10. Error Recovery

This section details how interactive interfaces handle validation errors and recovery prompts:

### Success Feedback Motion
Success feedback confirms positive system events, such as successful database backups, verified PIN creation, or successful transaction template matches:
* **Subtle Confirmed State:** Success states utilize a quiet, non-playful animation. A circular checkmark badge scales up slightly while its internal path draws in smoothly, using the decelerate curve token `bankyar.motion.curve.decelerate`.
* **Automatic Dismissal:** The success view must dismiss itself automatically after a brief, stable duration, returning the user to their active task with zero extra taps.
* **Path Stroke Drawing:** The checkmark outline uses a path-stroke animation, drawing from start to finish to confirm the state change.

### Error Feedback Motion
Error feedback highlights critical failures that require user attention, such as PIN mismatch lockouts, SQLCipher database corruption, or invalid import formats:
* **Anxiety-Free Shakes:** In input forms (such as PIN entry), a validation error triggers a subtle, horizontal shake animation. The shake moves horizontally along a tight axis, using a linear curve before returning to its center. No vertical bouncing is allowed.
* **Visual Isolation:** The error banner fades in vertically above the form input field, drawing immediate focus to the validation message.
* **Transition Alert:** The container transitions its border color to the semantic error status color instantly, providing clear feedback.

### Interaction for Error Scenarios
* **Validation Errors:** Form fields apply a red border highlight instantly. Text labels display the validation error with a subtle fade-in.
* **System Errors:** If local storage writes fail, an alert bottom sheet transitions upward with diagnostic details and a safe retry trigger.
* **Permission Errors:** Tapping blocked components triggers a lateral shift toward the permission overview panel, highlighting the missing toggle.
* **Storage Errors:** Out-of-memory or file export locks display a modal sheet with clear instructions to clear cache files.
* **Security Errors:** PIN verification failures lock the input for a duration, displaying a circular progress countdown indicator.
* **Unexpected Failures:** Generic exceptions display a non-intrusive snackbar alert with a direct option to retry the failed task.
* **Recovery Suggestions:** Error interfaces do not just report failures; they fade in contextual tips (such as "Verify file format") directly beneath the action area.
* **Retry Patterns:** Primary action buttons on error panels transition into a rotating loading state when clicked, allowing immediate retries of the background operation.

---

## 11. Accessibility

### Accessibility Strategy
The accessibility strategy ensures that the application remains usable and comfortable for all users, including those with visual impairments or motion sensitivities:
* **Contrast Integrity:** Text elements inside animated components must maintain high contrast ratios against their backgrounds under all lighting conditions.
* **Reduced Motion Support:** The system must detect when the user has enabled "Reduce Motion" in their system settings, immediately switching animations to instant durations.
* **Screen Reader Support:** Screen readers must read the final, resolved state of animated components immediately, avoiding reading intermediate transition states.
* **Dynamic Text Scaling:** Animated cards and forms must scale vertically to support high levels of text magnification without clipping text.
* **Focus Order Alignment:** Focus transitions match visual reading direction, avoiding random spatial jumps during layout shifts.

### Reduced Motion Strategy
Reduced Motion settings protect users who experience discomfort or motion sickness from animations:
* **Instant State Switches:** When "Reduce Motion" is enabled in system settings, all motion durations are immediately set to `bankyar.motion.duration.instant`.
* **Transitions Override:** Sliding sheets and scaling dialogs switch to simple opacity fade-ins, ensuring the interface remains completely flat and static.
* **Alternative Animations:** Complex structural transforms default to instant opacity cross-fades, avoiding all spatial translating and scaling.

### Dark Mode Considerations
Dark Mode considerations optimize visual transitions for low-light environments, protecting eye health during night-time reviews:
* **No High-Contrast Flashes:** Opacity transitions must be carefully balanced to prevent sudden flashes of light when opening modals against deep gray canvases.
* **Elevation via Opacity:** Instead of heavy shadows, elevation changes in dark mode are communicated by applying soft white opacity overlays to container surfaces.
* **Phosphor Ghosting Mitigation:** Easing curves and timings are optimized to reduce visual smearing on OLED screens during fast scrolling.

### Inclusive Design Features
* **Screen Reader Compatibility:** Complex state changes (such as expanding list details) trigger immediate screen reader announcements.
* **Motion Safety:** Visual flashes, vertical screen-bounces, and multi-axis animations are strictly prohibited.
* **Large Font Compatibility:** Expandable cards utilize flexible column heights to ensure that large text scales do not result in clipped layouts.
* **High Contrast Compatibility:** High-contrast settings swap active tokens with extreme-contrast outlines, disabling translucent opacity layers.

---

## 12. Flutter Alignment

This section defines how the abstract Motion and Interaction Design System translates directly into Flutter's rendering architecture, ensuring consistent and maintainable implementation:

* **No Code Generation:** The design system is implementation-agnostic, relying entirely on native framework parameters.
* **Implicit Animation Optimization:** Simple component states (such as hover and press highlights) are achieved using built-in, lightweight state management structures to avoid rendering overhead.
* **Explicit Controller Coordination:** Large structural transitions (such as container transforms and bottom sheets) utilize coordinated animation controllers to enforce clean sequential steps.
* **State Management Isolation:** Riverpod state changes trigger layout updates cleanly. Animations listen to these state changes without introducing rendering rebuilds on parent widgets.
* **Layout Stability:** Expandable list items and sheets must pre-calculate heights or utilize flexible constraints to prevent unexpected layout shifts during rendering.

### Performance Budget
To ensure BankYar remains lightweight, responsive, and battery-efficient on low-end Android hardware, all animations must adhere to a strict performance budget:
* **60 FPS Minimum Guarantee:** Scroll feeds, list transitions, and interactive buttons must maintain a minimum rendering speed of sixty frames per second.
* **120 FPS Native Support:** Devices with high refresh rate displays (such as flagship Android and iOS devices) must render transitions at one hundred and twenty frames per second.
* **GPU Overdraw Prevention:** Complex animations must avoid overlapping semi-transparent layers. Background surfaces must remain flat to prevent GPU overdraw.
* **No Layout Recalculations:** Animations must only modify transform and opacity properties. Modifying spatial dimensions (such as width, height, or padding) during animation is prohibited, as it forces expensive layout recalculations.
* **Graceful Interruption:** If a user initiates a new transition while an animation is running, the active animation must terminate immediately and transition to the new state without causing UI stuttering.

---

## 13. Quality Checklist

### Governance Rules
Governance rules protect the design system from inconsistent additions, visual clutter, and unnecessary animations:
1. **Mandatory Token Usage:** Every animation, timing, and curve must reference an active design token. Hardcoded visual values are strictly prohibited.
2. **No Decorative Animations:** Animations must only be used to communicate structure, focus, or system status. Purely decorative movements are prohibited.
3. **Graceful Interruptions:** All animations must support instant interruption or cancellation, returning control to the user immediately.
4. **Reduced Motion Compliance:** Every new animation must support reduced motion settings, switching to instant transitions automatically.
5. **Approval Required:** Any addition of new curves or transition patterns to the system requires approval from the Design System Governance Board.

### Validation Rules
The design system compiler validates all motion definitions against a strict rule set before deployment:
* **VAL-MOT-01:** Motion files must not contain raw duration integers. All timings must reference active duration tokens.
* **VAL-MOT-02:** Motion files must not contain raw cubic bezier coordinates. Easing must map directly to system curve tokens.
* **VAL-MOT-03:** Horizontal translations must utilize logical start and logical end coordinates to support seamless RTL layout mirroring.
* **VAL-MOT-04:** Animated layers must avoid nested opacity modifiers to protect the GPU from overdraw.
* **VAL-MOT-05:** Every structural transition must provide a verified fallback state for reduced motion overrides.

### Anti-pattern Catalog
The following visual, architectural, and motion anti-patterns are strictly prohibited:
* **Hardcoded Timing Parameters:** Specifying raw numerical durations or cubic easing coordinates directly in layout styles instead of referencing active design tokens.
* **Bouncy Elastic Scales:** Using dramatic spring animations, elastic bounces, or heavy physical overshoots, which break our professional tone.
* **Uninterruptible Transitions:** Locking user inputs during transitions, forcing the user to wait for animations to complete before interacting.
* **Horizontal Gestures for Deletion:** Triggering destructive actions (such as card deletion) with horizontal swipes without an explicit secondary confirmation.
* **Competing Animations:** Animating multiple independent elements simultaneously on a single screen, which increases cognitive load and causes UI stuttering.

### Motion Review Checklist
Before releasing any screen, transition, or interactive element, verify compliance against this checklist:
- [ ] Does the animation reference a semantic motion token, avoiding hardcoded values?
- [ ] Is the animation strictly functional, avoiding pure decoration?
- [ ] Does the animation complete within our performance budget, maintaining 60 FPS?
- [ ] Does the transition support instant interruption, returning control to the user?
- [ ] Does the element support Reduced Motion settings, switching to instant transitions?
- [ ] Does the motion align with our Persian RTL-first directionality?
- [ ] Is the transition paired with comfortable haptic feedback?

### Migration Strategy
To transition the existing codebase to the structured Motion & Interaction System, developers follow a phased migration plan:
1. **Audit & Map (Phase 1):** Identify and map all raw animation durations, cubic curves, and transitions in the codebase, establishing corresponding tokens in the design dictionary.
2. **Asset Cleanup (Phase 2):** Replace custom curves and raw timings with standard system tokens, ensuring uniform transitions across all features.
3. **Refactor UI (Phase 3):** Apply motion tokens and haptic feedback configurations across all UI components, and run performance diagnostics to verify 60 FPS rendering.

### Future Evolution Strategy
As BankYar expands, the Motion & Interaction Design System is built to scale:
* **AI Assistant:** Future AI parsing assistants will use dynamic line progress and organic pulsing shimmers that scale up smoothly to represent deep parsing cycles, ensuring the transition from raw text is legible.
* **Voice Interaction:** Speech capture states will use localized indicator waves translating outwards from the search bar center, matching the amplitude.
* **Wear OS:** Spacing and duration tokens scale to match compact circular screen limits, adapting transitions to shorter pathways.
* **Foldables:** Transitions handle dual-screen fold splits dynamically, translating content containers to separate screen halves during detail expansions without breaking spatial continuity.
* **Desktop:** Pointer coordinates determine hover scaling effects, adapting components to standard cursor selections.
* **Multi-window:** Layout structures scale dynamically when resizing screen boundaries, transitioning components from expanded columns to single-column feeds smoothly.

---
**End of Document**
