import Link from "next/link"

export default function DocsPage() {
  return (
    <article className="max-w-2xl">
      <h1 className="text-3xl font-bold tracking-tight mb-2">Introduction</h1>
      <p className="text-lg text-muted-foreground mb-8">
        A code-first SwiftUI component kit. Copy components into your project and own the code.
      </p>

      <section className="space-y-4 text-[15px] leading-relaxed text-foreground/90">
        <p>
          <strong>S0</strong> is a collection of beautifully crafted SwiftUI components you can copy
          and paste into your apps. No package dependency, no lock-in — you own every line of code.
        </p>
        <p>
          Every component is built on a shared design-token system (spacing, radius, typography,
          colors, shadows, animation) so they look consistent out of the box and are trivial to
          theme.
        </p>
        <p>
          The CLI makes it fast: run{" "}
          <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">s0 add button</code>{" "}
          and the component lands in your project ready to use.
        </p>
      </section>

      <div className="mt-10 flex flex-wrap gap-3">
        <Link
          href="/docs/getting-started"
          className="inline-flex items-center bg-primary text-primary-foreground text-sm font-medium px-5 py-2 hover:bg-primary/90 transition-colors"
        >
          Get started →
        </Link>
        <Link
          href="/docs/components"
          className="inline-flex items-center border border-border text-sm font-medium px-5 py-2 text-foreground hover:border-primary/50 hover:text-primary transition-colors"
        >
          Browse components
        </Link>
      </div>
    </article>
  )
}
