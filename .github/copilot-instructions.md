# S0 — Copilot Instructions

## What is S0?

S0 is a code-first SwiftUI component kit inspired by shadcn/ui. Components are copied into the user's project (not installed as a dependency), giving them full ownership and customization. The philosophy is **"own the code, own the look"** — we do not chase native platform styles (e.g., Liquid Glass) at the framework level.

## Monorepo Structure

```
registry/              ← Source of truth for components and theme
  styles/S0Theme.swift
  ui/Button.swift, Card.swift, ...
registry.json          ← Component metadata (name, category, description, files, dependencies)
apps/S0-Showcase/      ← Native iOS/macOS demo app
apps/web/              ← Next.js marketing & docs site
packages/s0-cli/       ← Swift CLI tool (init, add, list)
test-project/          ← Example output of `s0 init && s0 add ...`
```

### Sync requirement

The registry is the single source of truth. When you change a component or the theme:

1. Edit the file in `registry/`
2. Copy it to `apps/S0-Showcase/Sources/S0-Showcase/S0/`
3. Copy it to `test-project/S0/` (if that component exists there)
4. If you changed `S0Theme.swift`, also update the inline template string in `packages/s0-cli/Sources/s0/main.swift`

Always verify both targets build: `swift build` in `packages/s0-cli/` and `apps/S0-Showcase/`.

## Swift Conventions

### Namespace

All components and tokens live under the `S0` enum, defined in `S0Theme.swift`:

```swift
public enum S0 {
    public struct Theme { ... }
}
```

Components are added as extensions:

```swift
extension S0 {
    public struct Badge: View { ... }
}
```

### Naming

- Components: `S0.ComponentName` (e.g., `S0.Badge`, `S0.Toggle`)
- Enums that would shadow generics go at the `S0` level: `S0.ButtonVariant`, `S0.ButtonSize`
- Compound components use flat names: `S0.CardHeader`, `S0.CardContent`, `S0.CardFooter` (not nested inside a generic parent)
- Files: `PascalCase.swift` matching the primary component name

### Theme Tokens — Always Use Them

Never hardcode colors, spacing, font sizes, corner radii, or animation values. Always reference `S0.Theme`:

```swift
// ✅ Good
.padding(S0.Theme.Spacing.lg)
.font(S0.Theme.Typography.headline)
.cornerRadius(S0.Theme.Radius.md)
.animation(S0.Theme.Animation.fast, value: isPressed)
.foregroundColor(S0.Theme.Colors.mutedForeground)
.s0Shadow(.sm)

// ❌ Bad
.padding(16)
.font(.system(size: 17, weight: .semibold))
.cornerRadius(8)
.animation(.easeOut(duration: 0.1), value: isPressed)
```

### Available Tokens

| Category | Values |
|----------|--------|
| **Spacing** | `xxs` (2), `xs` (4), `sm` (8), `md` (12), `lg` (16), `xl` (24), `xxl` (32) |
| **Radius** | `sm` (4), `md` (8), `lg` (12), `xl` (16), `full` (pill) |
| **Typography** | `largeTitle`, `title`, `headline`, `body`, `callout`, `subheadline`, `footnote`, `caption`, `button` |
| **Colors** | `primary`, `primaryForeground`, `secondary`, `secondaryBackground`, `secondaryForeground`, `destructive`, `destructiveForeground`, `success`, `successForeground`, `warning`, `warningForeground`, `muted`, `mutedForeground`, `background`, `foreground`, `card`, `cardForeground`, `border` |
| **Shadows** | `sm`, `md`, `lg` (apply with `.s0Shadow(.sm)`) |
| **Animation** | `fast`, `default`, `slow`, `spring` |

### Cross-Platform Colors

S0 targets iOS 17+ and macOS 14+. Platform-specific colors must use `#if canImport`:

```swift
#if canImport(UIKit)
public static let background = Color(uiColor: .systemBackground)
#elseif canImport(AppKit)
public static let background = Color(nsColor: .windowBackgroundColor)
#endif
```

Never use bare `UIColor` or `NSColor` without a platform guard. Cross-platform colors like `Color.primary`, `Color.red`, etc. need no guard.

### Component Structure

Every component should:

1. Be defined as an `extension S0 { }` in its own file
2. Use `@ViewBuilder` for content closures
3. Provide a convenience `init(_ title: String, ...)` when the label is just text
4. Use theme tokens exclusively — zero hardcoded values
5. Support light and dark mode (automatic via semantic theme colors)
6. Work on both iOS and macOS

## Adding a New Component (Checklist)

1. Create `registry/ui/ComponentName.swift`
2. Add entry to `registry.json` with name, category, description, files, dependencies
3. Copy the file to `apps/S0-Showcase/Sources/S0-Showcase/S0/UI/`
4. Add a showcase section in `apps/S0-Showcase/.../ContentView.swift`
5. Build both `s0-cli` and `S0-Showcase` to verify
6. Update `apps/web` component listings if applicable

## Commit Convention

Use **Conventional Commits** — Release Please auto-generates changelogs and version bumps from these:

- `feat: add DatePicker component` → bumps **minor** (0.1.0 → 0.2.0)
- `fix: resolve color issue on macOS` → bumps **patch** (0.1.0 → 0.1.1)
- `chore: update dependencies` → no version bump
- `docs: add DatePicker documentation` → no version bump
- `feat!: redesign theme API` → bumps **major** (breaking change)

Always use lowercase, no period at end. Body/footer optional.

## Branching & Workflow

**Never push directly to `main`.** The `main` branch is protected with rulesets.

1. Create a feature branch: `git checkout -b feat/my-feature`
2. Commit with conventional commits
3. Push and open a PR to `main`
4. CI must pass before merging
5. Merge the PR → Release Please picks up the commits

This gives us:
- **Rollback** — revert any PR with one click
- **CI gate** — broken code never reaches main
- **Clean history** — each feature is a discrete, revertable unit

## CLI

The CLI (`packages/s0-cli`) uses Swift Argument Parser. Commands:

- `s0 init` — scaffolds `S0/Styles/S0Theme.swift` in the current directory
- `s0 add <name>` — copies a component from the registry into `S0/UI/`
- `s0 remove <name>` — removes a component from the project
- `s0 update <name>` — re-copies a component from the registry
- `s0 list` — prints available components grouped by category
- `s0 doctor` — validates project structure
- `s0 --version` — prints current version

The `init` command contains an inline copy of `S0Theme.swift` as a string literal. Keep it in sync with `registry/styles/S0Theme.swift`.

### Version Management

The CLI version is defined in `packages/s0-cli/Sources/s0/main.swift`:

```swift
let s0Version = "0.1.0" // x-release-please-version
```

**Do not manually edit this line.** Release Please updates it automatically via the `x-release-please-version` annotation.

## Release Flow

The release process is fully automated:

1. **Branch** — work on a feature branch, open a PR to `main`
2. **CI** — runs on the PR, must pass before merge
3. **Merge** — merge the PR using conventional commit messages
4. **Release Please** (`release-please.yml`) runs on every push to `main` and creates/updates a release PR with:
   - Version bump in `S0CLI.swift` and `version.txt`
   - Auto-generated `CHANGELOG.md`
5. **Merge the release PR** → Release Please tags the commit (e.g., `v0.4.0`)
6. **Build job** chains automatically (same workflow) and:
   - Builds a universal macOS binary (arm64 + x86_64)
   - Creates a GitHub Release with the binary attached
   - Updates the Homebrew formula in `iampoul/homebrew-s0`

### Key Files

| File | Purpose |
|------|---------|
| `release-please-config.json` | Release Please config (scoped to CLI/registry) |
| `.release-please-manifest.json` | Tracks current version (auto-updated) |
| `version.txt` | Single source of truth for version number |
| `.github/workflows/release-please.yml` | Creates release PRs + builds binary + updates Homebrew |

### Homebrew Distribution

The CLI is distributed via a Homebrew tap:

```sh
brew install iampoul/s0/s0
```

The tap repo (`iampoul/homebrew-s0`) is auto-updated by the release workflow. The `HOMEBREW_TAP_TOKEN` secret (fine-grained PAT with Contents write access to `homebrew-s0`) must be set in the `s0` repo's Actions secrets.

## Web (Next.js)

- Framework: Next.js 16, React 19, TailwindCSS 4
- The web app is a marketing and documentation site, not a component library
- Component previews use placeholder images (not live SwiftUI rendering)

## Design Philosophy

- **Code-first**: Users copy source files, not install packages
- **Own the look**: S0 has its own visual identity; we don't adapt to platform-specific styles like Liquid Glass
- **Token-driven**: Every visual property flows from `S0.Theme`
- **Minimal dependencies**: SwiftUI components use zero external packages
