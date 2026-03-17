import { Layers, Zap, Shield, GitBranch, Monitor, Package } from "lucide-react"

const features = [
  {
    icon: Layers,
    title: "Composable by design",
    description:
      "Every component exposes a clean, composable API. Mix, match, and extend without fighting the framework.",
  },
  {
    icon: Zap,
    title: "Zero configuration",
    description:
      "Drop S0 into your project and start building. No setup files, no config objects, no ceremony.",
  },
  {
    icon: Shield,
    title: "Accessibility first",
    description:
      "VoiceOver, Dynamic Type, and reduced motion support are baked into every component from day one.",
  },
  {
    icon: GitBranch,
    title: "Versioned & stable",
    description:
      "Semantic versioning, a public changelog, and migration guides — so upgrades are never a surprise.",
  },
  {
    icon: Monitor,
    title: "Multi-platform",
    description:
      "iOS, macOS, watchOS, and visionOS. One API, every Apple platform, all adaptive by default.",
  },
  {
    icon: Package,
    title: "Own the code",
    description:
      "Not a dependency. Components are added directly to your project via CLI. Customize them as you see fit.",
  },
]

export function Features() {
  return (
    <section className="py-20 px-6 border-t border-border">
      <div className="mx-auto max-w-6xl">
        {/* Section header */}
        <div className="mb-12">
          <p className="font-mono text-xs text-primary uppercase tracking-widest mb-3">Why S0</p>
          <h2 className="text-3xl md:text-4xl font-bold tracking-tight text-foreground text-balance">
            Engineered for Apple platforms.
          </h2>
        </div>

        {/* Grid */}
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-px bg-border">
          {features.map(({ icon: Icon, title, description }) => (
            <div
              key={title}
              className="group bg-background hover:bg-card transition-colors duration-200 p-8 flex flex-col gap-4"
            >
              <div className="w-8 h-8 flex items-center justify-center border border-border group-hover:border-primary/40 transition-colors duration-200">
                <Icon size={16} className="text-primary" />
              </div>
              <div>
                <h3 className="font-semibold text-foreground mb-1.5">{title}</h3>
                <p className="text-sm text-muted-foreground leading-relaxed">{description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
