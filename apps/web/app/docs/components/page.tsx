import Link from "next/link"
import { components, categories, type ComponentDoc } from "@/lib/docs-data"

function CategorySection({
  category,
  items,
}: {
  category: keyof typeof categories
  items: ComponentDoc[]
}) {
  return (
    <section className="mb-12">
      <h2 className="text-xl font-semibold mb-4">{categories[category]}</h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
        {items.map((c) => (
          <Link
            key={c.slug}
            href={`/docs/components/${c.slug}`}
            className="group block border border-border rounded-sm p-4 hover:border-primary/50 transition-colors"
          >
            <h3 className="font-mono text-sm font-medium text-foreground group-hover:text-primary transition-colors">
              {c.name}
            </h3>
            <p className="text-xs text-muted-foreground mt-1 line-clamp-2">
              {c.description}
            </p>
          </Link>
        ))}
      </div>
    </section>
  )
}

export default function ComponentsPage() {
  const primitives = components.filter((c) => c.category === "primitives")
  const forms = components.filter((c) => c.category === "forms")
  const layout = components.filter((c) => c.category === "layout")

  return (
    <article className="max-w-3xl">
      <h1 className="text-3xl font-bold tracking-tight mb-2">Components</h1>
      <p className="text-lg text-muted-foreground mb-10">
        {components.length} SwiftUI components you can copy into your project.
      </p>

      <CategorySection category="primitives" items={primitives} />
      <CategorySection category="forms" items={forms} />
      <CategorySection category="layout" items={layout} />
    </article>
  )
}
