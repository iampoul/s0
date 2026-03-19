import { notFound } from "next/navigation"
import Link from "next/link"
import { components, getComponentBySlug, categories } from "@/lib/docs-data"

export function generateStaticParams() {
  return components.map((c) => ({ slug: c.slug }))
}

function CodeBlock({ children }: { children: string }) {
  return (
    <pre className="bg-muted/60 border border-border rounded-sm p-4 overflow-x-auto">
      <code className="font-mono text-sm text-foreground">{children}</code>
    </pre>
  )
}

export default async function ComponentPage({
  params,
}: {
  params: Promise<{ slug: string }>
}) {
  const { slug } = await params
  const component = getComponentBySlug(slug)

  if (!component) {
    notFound()
  }

  const currentIndex = components.findIndex((c) => c.slug === slug)
  const prev = currentIndex > 0 ? components[currentIndex - 1] : null
  const next = currentIndex < components.length - 1 ? components[currentIndex + 1] : null

  return (
    <article className="max-w-2xl">
      {/* Breadcrumb */}
      <div className="flex items-center gap-1.5 text-xs text-muted-foreground mb-6">
        <Link href="/docs/components" className="hover:text-foreground transition-colors">
          Components
        </Link>
        <span>/</span>
        <span className="text-foreground">{categories[component.category]}</span>
        <span>/</span>
        <span className="text-foreground">{component.name}</span>
      </div>

      {/* Header */}
      <h1 className="text-3xl font-bold tracking-tight mb-2">{component.name}</h1>
      <p className="text-lg text-muted-foreground mb-2">{component.description}</p>
      <p className="text-xs font-mono text-muted-foreground mb-8">
        <code className="bg-muted px-1.5 py-0.5 rounded-sm">s0 add {component.slug}</code>
      </p>

      {/* Usage */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-4">Usage</h2>
        <div className="space-y-4">
          {component.usage.map((code, i) => (
            <CodeBlock key={i}>{code}</CodeBlock>
          ))}
        </div>
      </section>

      {/* Props */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-4">Parameters</h2>
        <div className="overflow-x-auto border border-border rounded-sm">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border bg-muted/40">
                <th className="text-left font-medium px-4 py-2 text-foreground">Name</th>
                <th className="text-left font-medium px-4 py-2 text-foreground">Type</th>
                <th className="text-left font-medium px-4 py-2 text-foreground">Default</th>
                <th className="text-left font-medium px-4 py-2 text-foreground">Description</th>
              </tr>
            </thead>
            <tbody>
              {component.props.map((prop) => (
                <tr key={prop.name} className="border-b border-border last:border-0">
                  <td className="px-4 py-2 font-mono text-xs text-primary">{prop.name}</td>
                  <td className="px-4 py-2 font-mono text-xs text-foreground/80">{prop.type}</td>
                  <td className="px-4 py-2 font-mono text-xs text-muted-foreground">
                    {prop.default ?? "—"}
                  </td>
                  <td className="px-4 py-2 text-xs text-foreground/90">{prop.description}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      {/* Prev/Next navigation */}
      <div className="flex justify-between items-center pt-6 border-t border-border">
        {prev ? (
          <Link
            href={`/docs/components/${prev.slug}`}
            className="text-sm text-muted-foreground hover:text-primary transition-colors"
          >
            ← {prev.name}
          </Link>
        ) : (
          <span />
        )}
        {next ? (
          <Link
            href={`/docs/components/${next.slug}`}
            className="text-sm text-muted-foreground hover:text-primary transition-colors"
          >
            {next.name} →
          </Link>
        ) : (
          <span />
        )}
      </div>
    </article>
  )
}
