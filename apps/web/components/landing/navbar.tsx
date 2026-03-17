"use client"

import { useState, useEffect } from "react"
import { Menu, X, Sun, Moon } from "lucide-react"
import { useTheme } from "next-themes"

export function Navbar() {
  const [open, setOpen] = useState(false)
  const { theme, setTheme } = useTheme()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  return (
    <header className="fixed top-0 left-0 right-0 z-50 border-b border-border bg-background/90 backdrop-blur-sm">
      <div className="mx-auto max-w-6xl px-6 h-14 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className="font-mono text-lg font-bold tracking-tighter text-foreground">
            S<span className="text-primary">0</span>
          </span>
        </div>

        <nav className="hidden md:flex items-center gap-8">
          {["Components", "Docs", "Pricing", "GitHub"].map((item) => (
            <a
              key={item}
              href="#"
              className="text-sm font-sans text-muted-foreground hover:text-foreground transition-colors duration-200"
            >
              {item}
            </a>
          ))}
        </nav>

        <div className="hidden md:flex items-center gap-3">
          <a href="#" className="text-sm font-sans text-muted-foreground hover:text-foreground transition-colors">
            Sign in
          </a>
          {mounted && (
            <button
              onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
              className="w-8 h-8 flex items-center justify-center border border-border text-muted-foreground hover:text-foreground hover:border-primary/50 transition-colors duration-200"
              aria-label="Toggle theme"
            >
              {theme === "dark" ? <Sun size={14} /> : <Moon size={14} />}
            </button>
          )}
          <a
            href="#"
            className="inline-flex items-center bg-primary text-primary-foreground text-sm font-medium font-sans px-4 py-1.5 hover:bg-primary/90 transition-colors"
          >
            Get started
          </a>
        </div>

        <button
          className="md:hidden text-muted-foreground hover:text-foreground"
          onClick={() => setOpen(!open)}
          aria-label="Toggle menu"
        >
          {open ? <X size={20} /> : <Menu size={20} />}
        </button>
      </div>

      {open && (
        <div className="md:hidden border-t border-border bg-background px-6 py-4 flex flex-col gap-4">
          {["Components", "Docs", "Pricing", "GitHub", "Sign in"].map((item) => (
            <a key={item} href="#" className="text-sm font-sans text-muted-foreground hover:text-foreground transition-colors">
              {item}
            </a>
          ))}
          {mounted && (
            <button
              onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
              className="flex items-center gap-2 text-sm font-sans text-muted-foreground hover:text-foreground transition-colors"
            >
              {theme === "dark" ? <Sun size={14} /> : <Moon size={14} />}
              {theme === "dark" ? "Light mode" : "Dark mode"}
            </button>
          )}
          <a href="#" className="inline-flex items-center justify-center bg-primary text-primary-foreground text-sm font-medium font-sans px-4 py-2 hover:bg-primary/90 transition-colors">
            Get started
          </a>
        </div>
      )}
    </header>
  )
}
