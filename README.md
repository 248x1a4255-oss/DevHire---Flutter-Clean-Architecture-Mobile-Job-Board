
📱 Features & Interactive Showcase


🔍 1. Decentralised Job Feed (Dashboard)

• Unified Pipeline Stream: Browse live, production-grade openings displaying multi-indexed role profiles at a glance.
• Metadata Rich Cards: Every card renders critical structural parameters: Role Title, Company Name, Location, Salary Matrices ($145k - $195k/yr), and relative posting timestamps.
• Workstyle & Terms Badges: Instant visual markers dividing roles by location structure (Remote, Hybrid, On-site) and employment layout (Full-time, Part-time, Contract).
• Composition Shimmer Skeletons: Jetpack Compose async placeholders that render elegant skeleton blocks to prevent UI structural layout shifts during asset fetching.

🎛️ 2. Dynamic Filtering & Search Engine

• Reactive Bottom Sheet Drawer: A contextual multi-select filter panel allowing instant extraction of job scopes without disruption.
• Keyword Matching Vector: Real-time search query matching across company listings, titles, and localized tags.
• State-Preserved Chip Selectors: Material Design 3 FilterChip items providing reactive feedback loops with a single-tap "Clear All" utility toggle.

📖 3. Immersive Job Details Engine

• Collapsible Top App Bar View: Utilizes dynamic nested scrolling inside Compose layouts to morph header typography into sub-elements on scroll.
• Structured Data Components: Clean, accessible typographic separation dividing text blocks into Job Descriptions, Required Qualifications, and Corporate Responsibilities.
• Sticky Navigation Footprint: A pinned bottom dashboard element housing interactive bookmark state toggles and the high-contrast "Apply Platform Now" trigger action.

📋 4. Secure Application Form & Validation Matrix

• StateFlow Reactive Constraints: Automated real-time state tracking that holds the form lifecycle in strict compliance before enabling downstream network actions.
• Built-in Validation Handlers: Advanced regular-expression (Regex) validation blocks guarding fields against structural entry errors:
	• Full Name: Required constraint checking minimum character limits.
	• Email Address: Regular expression matrix tracking structural token verification.
	• Phone Number: Enforces explicit numeric values and expected dial-string length.
• Pipeline Interface States: Smooth, conditional Compose state transitions driving the execution sequence: Idle ➔ Input Validation Error ➔ Coroutine Dispatching (Loading Spinner) ➔ Confetti Animation Success Dialog.
