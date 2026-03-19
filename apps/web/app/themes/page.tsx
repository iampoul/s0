import fs from "fs"
import path from "path"
import type { Metadata } from "next"
import { Navbar } from "@/components/landing/navbar"
import { Footer } from "@/components/landing/footer"
import { ThemeGrid } from "./theme-grid"

export const metadata: Metadata = {
  title: "Themes — S0",
  description: "Browse 15 built-in theme presets for S0 components. From minimal Zinc to neon Synthwave.",
}

interface ThemeColors {
  background: string
  foreground: string
  card: string
  cardForeground: string
  primary: string
  primaryForeground: string
  secondary: string
  secondaryForeground: string
  secondaryBackground: string
  muted: string
  mutedForeground: string
  border: string
  destructive: string
  destructiveForeground: string
  success: string
  successForeground: string
  warning: string
  warningForeground: string
}

interface ThemeDefinition {
  name: string
  label: string
  description: string
  builtin?: boolean
  colors?: {
    light: ThemeColors
    dark: ThemeColors
  }
}

interface ThemesFile {
  themes: ThemeDefinition[]
}

export default function ThemesPage() {
  const themesPath = path.join(process.cwd(), "..", "..", "registry", "themes.json")
  const raw = fs.readFileSync(themesPath, "utf-8")
  const { themes } = JSON.parse(raw) as ThemesFile

  return (
    <>
      <Navbar />
      <main className="min-h-screen bg-background pt-14">
        <div className="mx-auto max-w-6xl px-6 py-16">
          <div className="mb-12">
            <h1 className="font-mono text-3xl font-bold tracking-tight text-foreground mb-3">
              Themes
            </h1>
            <p className="text-muted-foreground font-sans max-w-2xl">
              {themes.length} built-in theme presets. Pick one with{" "}
              <code className="text-sm bg-muted px-1.5 py-0.5 font-mono">
                s0 init --theme &lt;name&gt;
              </code>{" "}
              or customize the generated S0Theme.swift to make it your own.
            </p>
          </div>

          <ThemeGrid themes={themes} />
        </div>
      </main>
      <Footer />
    </>
  )
}
