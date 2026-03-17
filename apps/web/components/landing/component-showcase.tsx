"use client"

import { useState } from "react"
import Link from "next/link"

const categoryFilters = ["All", "Primitives", "Forms", "Layout"] as const

const components = [
  { name: "S0.Button", slug: "button", category: "Primitives" },
  { name: "S0.Badge", slug: "badge", category: "Primitives" },
  { name: "S0.Toggle", slug: "toggle", category: "Primitives" },
  { name: "S0.Separator", slug: "separator", category: "Primitives" },
  { name: "S0.Avatar", slug: "avatar", category: "Primitives" },
  { name: "S0.Progress", slug: "progress", category: "Primitives" },
  { name: "S0.Spinner", slug: "spinner", category: "Primitives" },
  { name: "S0.Skeleton", slug: "skeleton", category: "Primitives" },
  { name: "S0.Card", slug: "card", category: "Layout" },
  { name: "S0.Tabs", slug: "tabs", category: "Layout" },
  { name: "S0.Alert", slug: "alert", category: "Layout" },
  { name: "S0.Sheet", slug: "sheet", category: "Layout" },
  { name: "S0.Accordion", slug: "accordion", category: "Layout" },
  { name: "S0.DropdownMenu", slug: "dropdown-menu", category: "Layout" },
  { name: "S0.Popover", slug: "popover", category: "Layout" },
  { name: "S0.Toast", slug: "toast", category: "Layout" },
  { name: "S0.Input", slug: "input", category: "Forms" },
  { name: "S0.Checkbox", slug: "checkbox", category: "Forms" },
  { name: "S0.RadioGroup", slug: "radio-group", category: "Forms" },
  { name: "S0.Select", slug: "select", category: "Forms" },
  { name: "S0.Slider", slug: "slider", category: "Forms" },
  { name: "S0.Stepper", slug: "stepper", category: "Forms" },
  { name: "S0.TextArea", slug: "textarea", category: "Forms" },
  { name: "S0.Label", slug: "label", category: "Forms" },
]

export function ComponentShowcase() {
  const [active, setActive] = useState<(typeof categoryFilters)[number]>("All")

  const filtered =
    active === "All" ? components : components.filter((c) => c.category === active)

  return (
    <section className="py-20 px-6 border-t border-border">
      <div className="mx-auto max-w-6xl">
        {/* Header */}
        <div className="mb-10">
          <p className="font-mono text-xs text-primary uppercase tracking-widest mb-3">Component library</p>
          <h2 className="text-3xl md:text-4xl font-bold tracking-tight text-foreground text-balance">
            {components.length} components, ready to use.
          </h2>
        </div>

        {/* Category filter */}
        <div className="flex flex-wrap gap-2 mb-8">
          {categoryFilters.map((cat) => (
            <button
              key={cat}
              onClick={() => setActive(cat)}
              className={`font-mono text-xs px-3 py-1.5 rounded-sm border transition-colors duration-150 ${
                active === cat
                  ? "border-primary bg-primary/10 text-primary"
                  : "border-border text-muted-foreground hover:border-primary/40 hover:text-foreground"
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        {/* Component grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-px bg-border">
          {filtered.map(({ name, slug }) => (
            <Link
              key={slug}
              href={`/docs/components/${slug}`}
              className="group bg-background hover:bg-card transition-colors duration-150 p-4 flex flex-col gap-2"
            >
              <div className="flex items-start justify-between">
                <span className="w-1.5 h-1.5 rounded-full bg-primary/50 mt-0.5" />
              </div>
              <span className="font-mono text-xs text-foreground group-hover:text-primary transition-colors duration-150">
                {name}
              </span>
            </Link>
          ))}
        </div>

        <div className="mt-6 text-center">
          <Link
            href="/docs/components"
            className="inline-flex items-center gap-2 font-mono text-xs text-muted-foreground hover:text-primary transition-colors duration-200 uppercase tracking-widest"
          >
            View all components →
          </Link>
        </div>
      </div>
    </section>
  )
}
