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

## Phase 5 — Testing & Polish ✅

### 5.1 CLI Tests ✅
- 31 integration tests using XCTest + Process
- Covers: init, add, remove, update, list, doctor
- Edge cases: missing registry, corrupt JSON, empty registry, unknown components, dependency resolution

### 5.2 Web Tests ✅
- 27 tests using Vitest + React Testing Library
- docs-data: component count, slug uniqueness, category validation, sidebar nav, getters
- ComponentShowcase: rendering, category filtering, link targets

### 5.3 CI/CD ✅
- GitHub Actions workflow (`.github/workflows/ci.yml`)
- CLI job: swift build + swift test on macOS
- Web job: pnpm install, vitest, next build on Ubuntu

---

## Phase 6 — Distribution & Polish

### 6.1 Remote Registry
- CLI fetches components from GitHub raw URL (`raw.githubusercontent.com/iampoul/s0/main/registry/`)
- `s0 add button` works without `--registry-path` by downloading from remote
- Local registry override via `s0.json` or `--registry-path` flag
- Cache downloaded components locally for offline use
- Version checking: compare local vs remote `registry.json`

### 6.2 Homebrew Distribution
- Create a Homebrew formula (`homebrew-s0` tap)
- `brew install iampoul/s0/s0` installs the CLI
- Automate release builds via GitHub Actions (universal macOS binary)
- Add `s0 --version` command tied to release tags

### 6.3 More Components
- Table — data table with sortable columns and rows
- SearchBar — styled search input with clear button and suggestions
- Dialog / AlertDialog — modal confirmation with actions
- DatePicker — styled date/time picker
- NavigationBar — custom navigation header
- SegmentedControl — horizontal segment picker
- Tooltip — floating hint on hover/long-press
- ScrollArea — styled scrollable container

### 6.4 Theming Presets
- Bundled theme packs: Default, Zinc, Slate, Rose, Blue, Green
- `s0 init --theme zinc` to scaffold with a preset
- Theme switcher in showcase app to preview all presets
- Document theming customization in docs site

### 6.5 Component Screenshots
- Auto-generate preview images from SwiftUI previews
- Add screenshots to docs site component pages
- Light + dark mode variants for each component
- Script to regenerate all screenshots in CI

### 6.6 Accessibility Audit
- VoiceOver labels and hints on all 24 components
- Dynamic Type support verified across all components
- Keyboard navigation (macOS) for interactive components
- Reduce Motion support for animated components
- Add accessibility section to each component doc page

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
