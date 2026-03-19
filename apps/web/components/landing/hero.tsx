import { ArrowRight, Terminal } from "lucide-react"
import fs from "fs"
import path from "path"
import { components } from "@/lib/docs-data"

function getVersion() {
  try {
    return fs.readFileSync(path.join(process.cwd(), "..", "..", "version.txt"), "utf-8").trim()
  } catch {
    return "0.0.0"
  }
}

export function Hero() {
  const version = getVersion()
  const componentCount = components.length

  return (
    <section className="relative pt-32 pb-20 px-6 overflow-hidden">
      {/* Grid background */}
      <div
        className="pointer-events-none absolute inset-0 opacity-[0.04]"
        style={{
          backgroundImage:
            "linear-gradient(var(--border) 1px, transparent 1px), linear-gradient(90deg, var(--border) 1px, transparent 1px)",
          backgroundSize: "48px 48px",
        }}
      />

      {/* Corner crosshairs */}
      <div className="pointer-events-none absolute top-16 left-6 w-4 h-4 border-l border-t border-primary/40" />
      <div className="pointer-events-none absolute top-16 right-6 w-4 h-4 border-r border-t border-primary/40" />

      <div className="relative mx-auto max-w-4xl text-center">
        {/* Badge */}
        <div className="inline-flex items-center gap-2 border border-border bg-card px-3 py-1 rounded-sm mb-8">
          <span className="w-1.5 h-1.5 rounded-full bg-primary animate-pulse" />
          <span className="font-mono text-xs text-muted-foreground tracking-widest uppercase">
            v{version} — Beta Launch
          </span>
        </div>

        {/* Headline */}
        <h1 className="font-sans text-5xl md:text-7xl font-bold tracking-tight text-balance leading-none mb-6">
          SwiftUI components
          <br />
          <span className="text-primary">built for speed.</span>
        </h1>

        {/* Subline */}
        <p className="text-base md:text-lg text-muted-foreground leading-relaxed text-pretty max-w-2xl mx-auto mb-10">
          S0 is the zero-friction SwiftUI component kit. Drop in production-ready views, modifiers, and design tokens — and ship your app faster than ever.
        </p>

        {/* CTAs */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-3 mb-14">
          <a
            href="/docs/components"
            className="inline-flex items-center gap-2 bg-primary text-primary-foreground font-medium text-sm px-6 py-3 rounded-sm hover:bg-primary/90 transition-colors duration-200"
          >
            Explore Registry
            <ArrowRight size={14} />
          </a>
          <div className="flex items-center gap-2 border border-border bg-black text-white font-mono text-xs px-4 py-3 rounded-sm">
            <Terminal size={14} className="text-primary" />
            <span className="opacity-70">$</span>
            <span>s0 init</span>
          </div>
        </div>

        {/* Stats row */}
        <div className="flex flex-col sm:flex-row items-center justify-center gap-8 sm:gap-12">
          {[
            { value: String(componentCount), label: "Components" },
            { value: "iOS 17+", label: "& macOS 14+" },
            { value: "MIT", label: "Open Source" },
            { value: "0 deps", label: "Native only" },
          ].map(({ value, label }) => (
            <div key={label} className="text-center">
              <div className="font-mono text-xl font-bold text-foreground">{value}</div>
              <div className="text-xs text-muted-foreground uppercase tracking-widest mt-0.5">{label}</div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
