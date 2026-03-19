"use client"

import { useState } from "react"

interface ThemeColors {
  background: string
  foreground: string
  card: string
  cardForeground: string
  primary: string
  primaryForeground: string
  secondary: string
  secondaryForeground: string
  muted: string
  mutedForeground: string
  border: string
  destructive: string
  success: string
  warning: string
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

function hexToStyle(hex: string): string {
  return `#${hex}`
}

function ThemeCard({ theme, mode }: { theme: ThemeDefinition; mode: "light" | "dark" }) {
  const isDefault = theme.builtin
  const colors = theme.colors?.[mode]

  // Default theme — use placeholder system colors
  const defaultLight = {
    background: "FFFFFF", foreground: "1C1C1E", primary: "007AFF",
    primaryForeground: "FFFFFF", secondary: "F2F2F7", secondaryForeground: "1C1C1E",
    card: "FFFFFF", cardForeground: "1C1C1E", muted: "F2F2F7",
    mutedForeground: "8E8E93", border: "D1D1D6", destructive: "FF3B30",
    success: "34C759", warning: "FF9500",
  }
  const defaultDark = {
    background: "1C1C1E", foreground: "F2F2F7", primary: "0A84FF",
    primaryForeground: "FFFFFF", secondary: "2C2C2E", secondaryForeground: "F2F2F7",
    card: "2C2C2E", cardForeground: "F2F2F7", muted: "2C2C2E",
    mutedForeground: "8E8E93", border: "38383A", destructive: "FF453A",
    success: "30D158", warning: "FF9F0A",
  }

  const c = colors ?? (mode === "dark" ? defaultDark : defaultLight)

  return (
    <div
      className="group relative rounded-lg border border-border/60 overflow-hidden transition-all hover:border-primary/40 hover:shadow-md"
    >
      {/* Mini UI preview */}
      <div
        className="p-4 space-y-3"
        style={{ backgroundColor: hexToStyle(c.background) }}
      >
        {/* Header bar */}
        <div className="flex items-center gap-2">
          <div
            className="h-2.5 w-2.5 rounded-full"
            style={{ backgroundColor: hexToStyle(c.destructive) }}
          />
          <div
            className="h-2.5 w-2.5 rounded-full"
            style={{ backgroundColor: hexToStyle(c.warning) }}
          />
          <div
            className="h-2.5 w-2.5 rounded-full"
            style={{ backgroundColor: hexToStyle(c.success) }}
          />
          <div className="flex-1" />
          <div
            className="h-2 w-12 rounded-full opacity-50"
            style={{ backgroundColor: hexToStyle(c.mutedForeground) }}
          />
        </div>

        {/* Card preview */}
        <div
          className="rounded-md p-3 space-y-2"
          style={{
            backgroundColor: hexToStyle(c.card),
            border: `1px solid ${hexToStyle(c.border)}`,
          }}
        >
          <div
            className="h-2 w-20 rounded-full"
            style={{ backgroundColor: hexToStyle(c.cardForeground) }}
          />
          <div
            className="h-1.5 w-32 rounded-full opacity-50"
            style={{ backgroundColor: hexToStyle(c.mutedForeground) }}
          />
        </div>

        {/* Button row */}
        <div className="flex gap-2">
          <div
            className="h-7 px-3 rounded-md flex items-center justify-center"
            style={{
              backgroundColor: hexToStyle(c.primary),
            }}
          >
            <div
              className="h-1.5 w-8 rounded-full"
              style={{ backgroundColor: hexToStyle(c.primaryForeground) }}
            />
          </div>
          <div
            className="h-7 px-3 rounded-md flex items-center justify-center"
            style={{
              backgroundColor: hexToStyle(c.secondary),
            }}
          >
            <div
              className="h-1.5 w-8 rounded-full"
              style={{ backgroundColor: hexToStyle(c.secondaryForeground) }}
            />
          </div>
        </div>

        {/* Color swatch row */}
        <div className="flex gap-1 pt-1">
          {[c.primary, c.destructive, c.success, c.warning, c.muted].map(
            (color, i) => (
              <div
                key={i}
                className="h-3 flex-1 rounded-sm first:rounded-l-md last:rounded-r-md"
                style={{ backgroundColor: hexToStyle(color) }}
              />
            )
          )}
        </div>
      </div>

      {/* Label */}
      <div className="px-4 py-3 border-t border-border/40 bg-card">
        <div className="flex items-center justify-between">
          <div>
            <p className="font-mono text-sm font-medium text-foreground">
              {theme.label}
              {isDefault && (
                <span className="ml-2 text-[10px] uppercase tracking-wider text-muted-foreground font-sans">
                  System
                </span>
              )}
            </p>
            <p className="text-xs text-muted-foreground font-sans mt-0.5 line-clamp-1">
              {theme.description}
            </p>
          </div>
        </div>
        <code className="text-[11px] text-muted-foreground font-mono mt-2 block">
          s0 init --theme {theme.name}
        </code>
      </div>
    </div>
  )
}

export function ThemeGrid({ themes }: { themes: ThemeDefinition[] }) {
  const [mode, setMode] = useState<"light" | "dark">("dark")

  return (
    <div>
      {/* Mode toggle */}
      <div className="flex items-center gap-2 mb-8">
        <span className="text-sm text-muted-foreground font-sans">Preview:</span>
        <button
          onClick={() => setMode("light")}
          className={`px-3 py-1 text-sm font-mono rounded-md transition-colors ${
            mode === "light"
              ? "bg-foreground text-background"
              : "bg-muted text-muted-foreground hover:text-foreground"
          }`}
        >
          Light
        </button>
        <button
          onClick={() => setMode("dark")}
          className={`px-3 py-1 text-sm font-mono rounded-md transition-colors ${
            mode === "dark"
              ? "bg-foreground text-background"
              : "bg-muted text-muted-foreground hover:text-foreground"
          }`}
        >
          Dark
        </button>
      </div>

      {/* Standard themes */}
      <div className="mb-12">
        <h2 className="font-mono text-lg font-semibold text-foreground mb-1">Standard</h2>
        <p className="text-sm text-muted-foreground font-sans mb-6">
          Clean, minimal palettes inspired by popular design systems.
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {themes
            .filter((t) => !["tokyo-night", "synthwave", "catppuccin", "nord", "dracula", "arcade", "sunset"].includes(t.name))
            .map((theme) => (
              <ThemeCard key={theme.name} theme={theme} mode={mode} />
            ))}
        </div>
      </div>

      {/* Creative themes */}
      <div>
        <h2 className="font-mono text-lg font-semibold text-foreground mb-1">Creative</h2>
        <p className="text-sm text-muted-foreground font-sans mb-6">
          Bold, expressive palettes for projects with personality.
        </p>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {themes
            .filter((t) => ["tokyo-night", "synthwave", "catppuccin", "nord", "dracula", "arcade", "sunset"].includes(t.name))
            .map((theme) => (
              <ThemeCard key={theme.name} theme={theme} mode={mode} />
            ))}
        </div>
      </div>
    </div>
  )
}
