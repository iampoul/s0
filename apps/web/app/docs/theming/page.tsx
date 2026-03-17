import Link from "next/link"

function CodeBlock({ children }: { children: string }) {
  return (
    <pre className="bg-muted/60 border border-border rounded-sm p-4 overflow-x-auto">
      <code className="font-mono text-sm text-foreground">{children}</code>
    </pre>
  )
}

function TokenTable({
  headers,
  rows,
}: {
  headers: string[]
  rows: string[][]
}) {
  return (
    <div className="overflow-x-auto border border-border rounded-sm">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-border bg-muted/40">
            {headers.map((h) => (
              <th key={h} className="text-left font-medium px-4 py-2 text-foreground">
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row, i) => (
            <tr key={i} className="border-b border-border last:border-0">
              {row.map((cell, j) => (
                <td key={j} className="px-4 py-2 text-foreground/90 font-mono text-xs">
                  {cell}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default function ThemingPage() {
  return (
    <article className="max-w-2xl">
      <h1 className="text-3xl font-bold tracking-tight mb-2">Theming</h1>
      <p className="text-lg text-muted-foreground mb-10">
        Customize every visual aspect through the S0 design-token system.
      </p>

      <section className="space-y-4 text-[15px] leading-relaxed text-foreground/90 mb-10">
        <p>
          All S0 components reference a central <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">S0.Theme</code>{" "}
          struct defined in <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">S0Theme.swift</code>.
          Changing a token value updates every component that uses it.
        </p>
      </section>

      {/* Spacing */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Spacing</h2>
        <TokenTable
          headers={["Token", "Value", "Usage"]}
          rows={[
            ["Spacing.xxs", "2 pt", "Tight gaps, required indicator offset"],
            ["Spacing.xs", "4 pt", "Inline spacing, label gaps"],
            ["Spacing.sm", "8 pt", "Icon-to-text gaps, compact padding"],
            ["Spacing.md", "12 pt", "Default horizontal padding, HStack spacing"],
            ["Spacing.lg", "16 pt", "Section padding, card padding"],
            ["Spacing.xl", "24 pt", "Large section spacing"],
            ["Spacing.xxl", "32 pt", "Extra-large button padding"],
          ]}
        />
      </section>

      {/* Radius */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Radius</h2>
        <TokenTable
          headers={["Token", "Value", "Usage"]}
          rows={[
            ["Radius.sm", "4 pt", "Checkboxes, small elements"],
            ["Radius.md", "8 pt", "Default component radius, inputs"],
            ["Radius.lg", "12 pt", "Cards, alerts, toasts"],
            ["Radius.xl", "16 pt", "Large containers"],
            ["Radius.full", "9999 pt", "Badges, avatars, pills"],
          ]}
        />
        <p className="text-sm text-muted-foreground mt-2">
          The default <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">Theme.radius</code>{" "}
          used by most components is <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">Radius.md</code> (8 pt).
        </p>
      </section>

      {/* Typography */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Typography</h2>
        <TokenTable
          headers={["Token", "Size", "Weight"]}
          rows={[
            ["Typography.largeTitle", "34 pt", "Bold"],
            ["Typography.title", "22 pt", "Bold"],
            ["Typography.headline", "17 pt", "Semibold"],
            ["Typography.body", "17 pt", "Regular"],
            ["Typography.callout", "16 pt", "Regular"],
            ["Typography.subheadline", "15 pt", "Regular"],
            ["Typography.footnote", "13 pt", "Regular"],
            ["Typography.caption", "12 pt", "Regular"],
            ["Typography.button", "14 pt", "Medium"],
          ]}
        />
      </section>

      {/* Colors */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Colors</h2>
        <p className="text-[15px] text-foreground/90 mb-3">
          Colors adapt automatically to light/dark mode via system APIs.
        </p>
        <TokenTable
          headers={["Token", "Light", "Dark"]}
          rows={[
            ["Colors.primary", "Color.primary", "Color.primary"],
            ["Colors.primaryForeground", "systemBackground", "windowBackgroundColor"],
            ["Colors.background", "systemBackground", "windowBackgroundColor"],
            ["Colors.card", "systemBackground", "windowBackgroundColor"],
            ["Colors.secondaryBackground", "secondarySystemBg", "controlBackgroundColor"],
            ["Colors.muted", "tertiarySystemFill", "underPageBgColor"],
            ["Colors.border", "separator", "separatorColor"],
            ["Colors.destructive", "Color.red", "Color.red"],
            ["Colors.success", "Color.green", "Color.green"],
            ["Colors.warning", "Color.orange", "Color.orange"],
          ]}
        />
      </section>

      {/* Shadows */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Shadows</h2>
        <TokenTable
          headers={["Token", "Radius", "Opacity", "Y Offset"]}
          rows={[
            ["Shadow.sm", "2 pt", "5%", "1 pt"],
            ["Shadow.md", "6 pt", "10%", "3 pt"],
            ["Shadow.lg", "15 pt", "15%", "8 pt"],
          ]}
        />
        <p className="text-sm text-muted-foreground mt-2">
          Apply with the <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">.s0Shadow(.md)</code> view modifier.
        </p>
      </section>

      {/* Animation */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Animation</h2>
        <TokenTable
          headers={["Token", "Curve", "Duration"]}
          rows={[
            ["Animation.fast", "easeOut", "0.1s"],
            ["Animation.default", "easeOut", "0.2s"],
            ["Animation.slow", "easeInOut", "0.35s"],
            ["Animation.spring", "spring(response: 0.35, damping: 0.7)", "—"],
          ]}
        />
      </section>

      {/* Customizing */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Customizing tokens</h2>
        <p className="text-[15px] text-foreground/90 mb-3">
          Since you own the code, just edit{" "}
          <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">S0Theme.swift</code>{" "}
          directly. For example, to change the default corner radius:
        </p>
        <CodeBlock>{`// S0Theme.swift
public struct Theme {
    // Change the default radius
    public static let radius: CGFloat = Radius.lg  // was Radius.md

    // Customize spacing
    public struct Spacing {
        public static let lg: CGFloat = 20  // was 16
    }
}`}</CodeBlock>
      </section>

      <div className="flex gap-3">
        <Link
          href="/docs/components"
          className="inline-flex items-center text-sm text-primary hover:underline"
        >
          Next: Components →
        </Link>
      </div>
    </article>
  )
}
