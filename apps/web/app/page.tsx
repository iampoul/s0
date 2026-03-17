import { Navbar } from "@/components/landing/navbar"
import { Hero } from "@/components/landing/hero"
import { CodePreview } from "@/components/landing/code-preview"
import { Features } from "@/components/landing/features"
import { ComponentShowcase } from "@/components/landing/component-showcase"
import { CTA } from "@/components/landing/cta"
import { Footer } from "@/components/landing/footer"

export default function HomePage() {
  return (
    <main className="min-h-screen bg-background text-foreground">
      <Navbar />
      <Hero />
      <CodePreview />
      <Features />
      <ComponentShowcase />
      <CTA />
      <Footer />
    </main>
  )
}
