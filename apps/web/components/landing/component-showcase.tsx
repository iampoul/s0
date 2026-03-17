"use client"

import { useState } from "react"

const categories = ["All", "Navigation", "Forms", "Feedback", "Layout", "Data"]

const components = [
  { name: "S0.Button", category: "Forms", status: "stable" },
  { name: "S0.Card", category: "Layout", status: "stable" },
  { name: "S0.Avatar", category: "Data", status: "stable" },
  { name: "S0.Badge", category: "Feedback", status: "stable" },
  { name: "S0.TabBar", category: "Navigation", status: "stable" },
  { name: "S0.TextField", category: "Forms", status: "stable" },
  { name: "S0.Toast", category: "Feedback", status: "stable" },
  { name: "S0.Sheet", category: "Layout", status: "stable" },
  { name: "S0.Sidebar", category: "Navigation", status: "beta" },
  { name: "S0.DataTable", category: "Data", status: "beta" },
  { name: "S0.Chart", category: "Data", status: "beta" },
  { name: "S0.Stepper", category: "Forms", status: "stable" },
  { name: "S0.Divider", category: "Layout", status: "stable" },
  { name: "S0.Spinner", category: "Feedback", status: "stable" },
  { name: "S0.SearchBar", category: "Navigation", status: "stable" },
  { name: "S0.Toggle", category: "Forms", status: "stable" },
  { name: "S0.Breadcrumb", category: "Navigation", status: "stable" },
  { name: "S0.Progress", category: "Feedback", status: "stable" },
]

export function ComponentShowcase() {
  const [active, setActive] = useState("All")

  const filtered =
    active === "All" ? components : components.filter((c) => c.category === active)

  return (
    <section className="py-20 px-6 border-t border-border">
      <div className="mx-auto max-w-6xl">
        {/* Header */}
        <div className="mb-10">
          <p className="font-mono text-xs text-primary uppercase tracking-widest mb-3">Component library</p>
          <h2 className="text-3xl md:text-4xl font-bold tracking-tight text-foreground text-balance">
            120+ components, ready to use.
          </h2>
        </div>

        {/* Category filter */}
        <div className="flex flex-wrap gap-2 mb-8">
          {categories.map((cat) => (
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
          {filtered.map(({ name, status }) => (
            <div
              key={name}
              className="group bg-background hover:bg-card transition-colors duration-150 p-4 flex flex-col gap-2"
            >
              <div className="flex items-start justify-between">
                {status === "beta" && (
                  <span className="font-mono text-[10px] text-primary/70 uppercase tracking-widest">beta</span>
                )}
                {status === "stable" && (
                  <span className="w-1.5 h-1.5 rounded-full bg-primary/50 mt-0.5" />
                )}
              </div>
              <span className="font-mono text-xs text-foreground group-hover:text-primary transition-colors duration-150">
                {name}
              </span>
            </div>
          ))}
        </div>

        <div className="mt-6 text-center">
          <a
            href="#"
            className="inline-flex items-center gap-2 font-mono text-xs text-muted-foreground hover:text-primary transition-colors duration-200 uppercase tracking-widest"
          >
            View all components →
          </a>
        </div>
      </div>
    </section>
  )
}
