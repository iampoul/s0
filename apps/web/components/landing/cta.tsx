import { ArrowRight } from "lucide-react"

export function CTA() {
  return (
    <section className="py-24 px-6 border-t border-border">
      <div className="mx-auto max-w-6xl">
        <div className="relative border border-border overflow-hidden">
          {/* Corner marks */}
          <div className="absolute top-4 left-4 w-4 h-4 border-l border-t border-primary/30" />
          <div className="absolute top-4 right-4 w-4 h-4 border-r border-t border-primary/30" />
          <div className="absolute bottom-4 left-4 w-4 h-4 border-l border-b border-primary/30" />
          <div className="absolute bottom-4 right-4 w-4 h-4 border-r border-b border-primary/30" />

          {/* Grid bg */}
          <div
            className="pointer-events-none absolute inset-0 opacity-[0.03]"
            style={{
              backgroundImage:
                "linear-gradient(var(--border) 1px, transparent 1px), linear-gradient(90deg, var(--border) 1px, transparent 1px)",
              backgroundSize: "32px 32px",
            }}
          />

          <div className="relative p-12 md:p-20 text-center">
            <p className="font-mono text-xs text-primary uppercase tracking-widest mb-6">
              Get started today
            </p>
            <h2 className="text-4xl md:text-6xl font-bold tracking-tight text-balance text-foreground mb-6">
              Start building with
              <br />
              <span className="text-primary">S0</span> today.
            </h2>
            <p className="text-muted-foreground max-w-xl mx-auto leading-relaxed mb-10">
              Free to use. MIT licensed. Zero vendor lock-in.
              Add S0 to your project via CLI and own your UI components.
            </p>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
              <a
                href="/docs/getting-started"
                className="inline-flex items-center gap-2 bg-primary text-primary-foreground font-medium text-sm px-8 py-3 rounded-sm hover:bg-primary/90 transition-colors duration-200"
              >
                Get started
                <ArrowRight size={14} />
              </a>
              <a
                href="/docs"
                className="inline-flex items-center gap-2 border border-border text-foreground text-sm font-medium px-8 py-3 rounded-sm hover:border-primary/50 transition-colors duration-200"
              >
                Read the docs
              </a>
            </div>

            {/* CLI snippet */}
            <div className="mt-10 inline-flex items-center gap-3 border border-border bg-card px-4 py-2 rounded-sm">
              <span className="font-mono text-xs text-muted-foreground">$</span>
              <span className="font-mono text-xs text-primary">s0 add</span>
              <span className="font-mono text-xs text-muted-foreground">button</span>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
