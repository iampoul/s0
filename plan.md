# S0 Roadmap

## Current State

S0 is a code-first SwiftUI component kit — like shadcn/ui for Apple platforms. The foundation is in place (CLI, registry, showcase app, marketing site) but each piece needs significant expansion.

**What exists today:**
- 3 SwiftUI components (Button, Card, Input) in the registry
- A Swift CLI with `init` and `add` commands (local registry only)
- An iOS-only showcase app demoing those 3 components
- A Next.js landing page (single marketing page, no docs)
- No tests anywhere

**Critical issues to fix first:**
- Components use `UIColor` (iOS-only) — blocks macOS support entirely
- Website lists 18 components that don't exist yet
- Theme system is too minimal to scale (no spacing, shadows, typography scale)

---

## Phase 1 — Foundation

Fix the platform and design system fundamentals so everything built on top is solid.

### 1.1 macOS Compatibility
- Replace all `UIColor` references with cross-platform color helpers (`#if os(iOS)` / `#if os(macOS)`)
- Update `Package.swift` in showcase to support `.macOS(.v14)`
- Verify all 3 existing components compile and render on macOS

### 1.2 Expand the Theme System
- **Spacing scale**: `xxs` (2), `xs` (4), `sm` (8), `md` (12), `lg` (16), `xl` (24), `xxl` (32)
- **Typography scale**: `largeTitle`, `title`, `headline`, `body`, `callout`, `caption`, `button`
- **Radius scale**: `sm` (4), `md` (8), `lg` (12), `xl` (16)
- **Shadow system**: `sm`, `md`, `lg` elevation tokens
- **Animation tokens**: standard durations and curves
- **Additional semantic colors**: `success`, `warning`, `info` + foregrounds

### 1.3 CLI Quality of Life
- `s0 list` — print available components from the registry with descriptions
- Better error messages with recovery suggestions
- Colored terminal output for better DX

---

## Phase 2 — Component Library Expansion

Build out the registry to cover the most common UI patterns. Each component should:
- Follow the existing `S0.ComponentName` namespace pattern
- Support light/dark mode via theme tokens
- Work on iOS 17+ and macOS 14+
- Include a section in the showcase app

### Primitives
- [ ] Badge — label with variant styling (default, secondary, destructive, outline)
- [ ] Toggle — styled switch with label
- [ ] Separator — horizontal/vertical divider
- [ ] Avatar — image with fallback initials
- [ ] Progress — determinate progress bar
- [ ] Spinner — indeterminate loading indicator
- [ ] Skeleton — placeholder loading shimmer

### Forms
- [ ] Checkbox — toggleable checkmark with label
- [ ] RadioGroup — single-select radio buttons
- [ ] Select / Picker — dropdown selection
- [ ] Slider — range input with track and thumb
- [ ] Stepper — increment/decrement control
- [ ] TextArea — multi-line text input
- [ ] Label — form field label with required indicator

### Layout & Navigation
- [ ] Sheet — bottom/side sheet modal
- [ ] Alert / AlertDialog — confirmation dialog
- [ ] Toast — non-blocking notification
- [ ] Tabs — segmented tab navigation
- [ ] Dropdown / Menu — contextual menu
- [ ] Popover — floating content panel
- [ ] Accordion — collapsible content sections

### Data Display
- [ ] Table — data table with rows and columns
- [ ] List — styled list with sections

---

## Phase 3 — Documentation Website

Transform the Next.js app from a single landing page into a full docs site.

### 3.1 Site Architecture
- Add routing: `/docs`, `/docs/components/[slug]`, `/docs/getting-started`, `/docs/theming`
- Sidebar navigation for docs section
- MDX or markdown-based content pages

### 3.2 Getting Started Guide
- Installation instructions (clone, Swift Package Manager)
- `s0 init` walkthrough
- Adding your first component
- Theming / customization guide

### 3.3 Component Documentation Pages
- One page per component at `/docs/components/button`, etc.
- Swift code examples with syntax highlighting
- Prop/parameter tables
- Placeholder images showing the component (screenshot from showcase app)
- Copy-paste snippets

### 3.4 Fix Component Showcase
- Remove fictional component listings from the landing page
- Only show components that actually exist in the registry
- Update dynamically from `registry.json` or keep in sync manually

---

## Phase 4 — CLI & Tooling

### 4.1 Project Config File
- Support `s0.json` at project root for configuration:
  ```json
  {
    "registryPath": "./registry",
    "outputPath": "./Sources/S0",
    "platforms": ["iOS", "macOS"]
  }
  ```
- CLI reads config automatically if present

### 4.2 Additional Commands
- `s0 remove <component>` — remove a component and warn about dependents
- `s0 update <component>` — re-copy from registry (with diff preview)
- `s0 doctor` — validate project structure and dependencies

### 4.3 Registry Improvements
- Add `version` field to each component in `registry.json`
- Add `platforms` field to declare platform compatibility
- Add `preview` field pointing to a screenshot image

---

## Phase 5 — Testing & Polish

### 5.1 CLI Tests
- Unit tests for `init` command (directory creation, file contents)
- Unit tests for `add` command (dependency resolution, file copying, skip existing)
- Unit tests for `list` command output
- Edge cases: missing registry, corrupt JSON, circular dependencies

### 5.2 Component Tests
- SwiftUI preview tests or snapshot tests for each component
- Verify all variants render without crashes
- Test light/dark mode, accessibility (Dynamic Type, VoiceOver labels)

### 5.3 Web Tests
- Component rendering tests for landing page sections
- Link/route validation

### 5.4 CI/CD
- GitHub Actions workflow for building the CLI
- GitHub Actions workflow for building the showcase app (iOS + macOS)
- GitHub Actions workflow for building/deploying the Next.js site
- Automated checks on PRs

---

## Component Naming Convention

All components live under the `S0` namespace:

```swift
// Usage
S0.Button("Label", variant: .primary) { }
S0.Card { S0.Card.Header { ... } }
S0.Badge("New", variant: .secondary)
S0.Toggle(isOn: $value) { Text("Dark Mode") }
```

## File Structure Convention

```
registry/
├── registry.json
├── styles/
│   └── S0Theme.swift
└── ui/
    ├── Button.swift
    ├── Card.swift
    ├── Input.swift
    ├── Badge.swift
    └── ...
```

After `s0 init && s0 add badge`:
```
YourProject/
└── S0/
    ├── Styles/
    │   └── S0Theme.swift
    └── UI/
        └── Badge.swift
```
