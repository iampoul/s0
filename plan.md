# S0 Roadmap

## Current State

S0 is a code-first SwiftUI component kit — like shadcn/ui for Apple platforms. The foundation is in place (CLI, registry, showcase app, marketing site) but each piece needs significant expansion.

**What exists today:**
- 3 SwiftUI components (Button, Card, Input) in the registry
- A Swift CLI with `init` and `add` commands (local registry only)
- A showcase app demoing those 3 components (iOS + macOS)
- A Next.js landing page (single marketing page, no docs)
- No tests anywhere

**Critical issues remaining:**
- ~~Components use `UIColor` (iOS-only) — blocks macOS support entirely~~ ✅ Fixed
- Website lists 18 components that don't exist yet
- Theme system is too minimal to scale (no spacing, shadows, typography scale)

---

## Phase 1 — Foundation

Fix the platform and design system fundamentals so everything built on top is solid.

### 1.1 macOS Compatibility ✅
- ~~Replace all `UIColor` references with cross-platform `Color(.system*)` initializers~~
- ~~Update `Package.swift` in showcase to support `.macOS(.v14)`~~
- ~~Verify all 3 existing components compile on macOS~~

### 1.2 Expand the Theme System ✅
- ~~Spacing, radius, typography, shadow, and animation token scales~~
- ~~Additional semantic colors (success, warning, mutedForeground, card)~~
- ~~Cross-platform colors via `#if canImport(UIKit/AppKit)`~~
- ~~Migrate all components to use theme tokens~~

### 1.3 CLI Quality of Life ✅
- ~~`s0 list` — print available components grouped by category with descriptions~~
- ~~Registry model updated with category and description fields~~

---

## Phase 2 — Component Library Expansion ✅

24 components built across 3 categories. All use theme tokens, support light/dark mode, iOS 17+ and macOS 14+, and are showcased in the app.

### Primitives ✅
Badge, Toggle, Separator, Avatar, Progress, Spinner, Skeleton

### Forms ✅
Input, Checkbox, RadioGroup, Select, Slider, Stepper, TextArea, Label

### Layout & Navigation ✅
Card, Tabs, Alert, Sheet, Accordion, DropdownMenu, Popover, Toast

---

## Phase 3 — Documentation Website ✅

Full docs site built with sidebar navigation, 31 static pages.

- ✅ `/docs` intro, `/docs/getting-started`, `/docs/theming`, `/docs/components` index
- ✅ 24 individual component pages at `/docs/components/[slug]`
- ✅ Landing page component showcase updated to match real registry

---

## Phase 4 — CLI & Tooling ✅

### 4.1 Project Config File ✅
- `s0.json` support at project root (registryPath, outputPath, platforms)
- CLI reads config automatically if present

### 4.2 Additional Commands ✅
- `s0 remove <component>` — removes component, warns about dependents, `--force` to skip prompt
- `s0 update <component>` — re-copies from registry (skips if unchanged)
- `s0 doctor` — validates S0 directory, theme file, installed components

### 4.3 Registry Improvements ✅
- Added `version` field to all 24 components in `registry.json`

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
