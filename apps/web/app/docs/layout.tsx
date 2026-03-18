"use client"

import { useState } from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { Menu, X, ChevronRight } from "lucide-react"
import { sidebarNav, categories } from "@/lib/docs-data"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Navbar } from "@/components/landing/navbar"

function SidebarContent({ onLinkClick }: { onLinkClick?: () => void }) {
  const pathname = usePathname()

  const isActive = (href: string) => pathname === href

  const linkClass = (href: string) =>
    `block text-[13px] py-1.5 px-2 rounded-md transition-colors duration-150 ${
      isActive(href)
        ? "bg-primary/10 text-primary font-medium"
        : "text-muted-foreground hover:text-foreground hover:bg-muted/50"
    }`

  return (
    <nav className="py-8 pr-2">
      {/* Getting Started */}
      <div className="mb-8">
        <h4 className="text-xs font-semibold uppercase tracking-widest text-foreground mb-3 px-2">
          Getting Started
        </h4>
        <ul className="space-y-0.5">
          {sidebarNav.gettingStarted.map((item) => (
            <li key={item.href}>
              <Link href={item.href} className={linkClass(item.href)} onClick={onLinkClick}>
                {item.title}
              </Link>
            </li>
          ))}
        </ul>
      </div>

      {/* Components header */}
      <div className="mb-4 px-2">
        <Link
          href="/docs/components"
          className={`text-xs font-semibold uppercase tracking-widest transition-colors duration-150 ${
            pathname === "/docs/components"
              ? "text-primary"
              : "text-foreground hover:text-primary"
          }`}
          onClick={onLinkClick}
        >
          Components
        </Link>
      </div>

      {/* Component categories */}
      {(Object.keys(sidebarNav.components) as Array<keyof typeof sidebarNav.components>).map(
        (cat) => (
          <div key={cat} className="mb-7">
            <p className="text-[11px] font-medium text-muted-foreground/70 uppercase tracking-wider mb-2 px-2">
              {categories[cat]}
            </p>
            <ul className="space-y-0.5">
              {sidebarNav.components[cat].map((item) => (
                <li key={item.href}>
                  <Link href={item.href} className={linkClass(item.href)} onClick={onLinkClick}>
                    {item.title}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        )
      )}
    </nav>
  )
}

export default function DocsLayout({ children }: { children: React.ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  return (
    <div className="min-h-screen bg-background text-foreground">
      <Navbar />
      {/* Top bar (mobile) */}
      <div className="sticky top-14 z-40 flex items-center gap-2 border-b border-border bg-background/90 backdrop-blur-sm px-6 py-2 lg:hidden">
        <button
          onClick={() => setSidebarOpen(!sidebarOpen)}
          className="inline-flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
          aria-label="Toggle sidebar"
        >
          {sidebarOpen ? <X size={16} /> : <Menu size={16} />}
          <span>Menu</span>
        </button>
        <ChevronRight size={12} className="text-muted-foreground" />
        <span className="text-sm text-foreground font-medium truncate">Docs</span>
      </div>

      <div className="mx-auto max-w-6xl flex">
        {/* Desktop sidebar */}
        <aside className="hidden lg:block w-64 shrink-0 sticky top-14 h-[calc(100vh-3.5rem)] border-r border-border pl-6 pt-14">
          <ScrollArea className="h-full">
            <SidebarContent />
          </ScrollArea>
        </aside>

        {/* Mobile sidebar overlay */}
        {sidebarOpen && (
          <>
            <div
              className="fixed inset-0 z-30 bg-background/80 backdrop-blur-sm lg:hidden"
              onClick={() => setSidebarOpen(false)}
            />
            <aside className="fixed top-[6.5rem] left-0 z-40 w-72 h-[calc(100vh-6.5rem)] border-r border-border bg-background px-6 lg:hidden overflow-y-auto">
              <SidebarContent onLinkClick={() => setSidebarOpen(false)} />
            </aside>
          </>
        )}

        {/* Main content */}
        <main className="flex-1 min-w-0 px-6 lg:px-12 py-10 pt-24 lg:pt-24">
          {children}
        </main>
      </div>
    </div>
  )
}
