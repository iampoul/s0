"use client"

import { useCallback, useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { FileText, Palette, Search, BookOpen, Component } from "lucide-react"
import {
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
  CommandShortcut,
} from "@/components/ui/command"
import { components, categories, sidebarNav } from "@/lib/docs-data"

export function SearchCommand() {
  const [open, setOpen] = useState(false)
  const [search, setSearch] = useState("")
  const router = useRouter()

  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault()
        setOpen((prev) => !prev)
      }
    }
    document.addEventListener("keydown", onKeyDown)
    return () => document.removeEventListener("keydown", onKeyDown)
  }, [])

  const handleOpenChange = useCallback((value: boolean) => {
    setOpen(value)
    if (!value) setSearch("")
  }, [])

  const navigate = useCallback(
    (href: string) => {
      setOpen(false)
      setSearch("")
      // Defer navigation so the dialog fully closes before the route change
      requestAnimationFrame(() => {
        router.push(href)
      })
    },
    [router],
  )

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="hidden md:inline-flex items-center gap-2 h-8 w-56 border border-border rounded-sm px-3 text-sm text-muted-foreground hover:text-foreground hover:border-primary/50 transition-colors duration-200"
      >
        <Search size={14} className="shrink-0" />
        <span className="flex-1 text-left text-xs">Search docs...</span>
        <kbd className="pointer-events-none hidden sm:inline-flex h-5 items-center gap-0.5 rounded border border-border bg-muted px-1.5 font-mono text-[10px] font-medium text-muted-foreground">
          ⌘K
        </kbd>
      </button>

      <button
        onClick={() => setOpen(true)}
        className="md:hidden w-8 h-8 flex items-center justify-center border border-border text-muted-foreground hover:text-foreground hover:border-primary/50 transition-colors duration-200"
        aria-label="Search"
      >
        <Search size={14} />
      </button>

      <CommandDialog
        open={open}
        onOpenChange={handleOpenChange}
        title="Search documentation"
        description="Search components, guides, and pages"
        showCloseButton={false}
      >
        <CommandInput placeholder="Search components, docs..." value={search} onValueChange={setSearch} />
        <CommandList>
          <CommandEmpty>No results found.</CommandEmpty>

          <CommandGroup heading="Getting Started">
            {sidebarNav.gettingStarted.map((item) => (
              <CommandItem
                key={item.href}
                value={item.title}
                onSelect={() => navigate(item.href)}
              >
                <BookOpen className="size-4 text-muted-foreground" />
                <span>{item.title}</span>
              </CommandItem>
            ))}
          </CommandGroup>

          <CommandSeparator />

          <CommandGroup heading="Pages">
            <CommandItem
              value="Themes"
              onSelect={() => navigate("/themes")}
            >
              <Palette className="size-4 text-muted-foreground" />
              <span>Themes</span>
            </CommandItem>
            <CommandItem
              value="Changelog"
              onSelect={() => navigate("/changelog")}
            >
              <FileText className="size-4 text-muted-foreground" />
              <span>Changelog</span>
            </CommandItem>
          </CommandGroup>

          <CommandSeparator />

          {(Object.keys(categories) as Array<keyof typeof categories>).map(
            (cat) => {
              const items = components.filter((c) => c.category === cat)
              if (items.length === 0) return null
              return (
                <CommandGroup key={cat} heading={categories[cat]}>
                  {items.map((c) => (
                    <CommandItem
                      key={c.slug}
                      value={`${c.name} ${c.description}`}
                      onSelect={() => navigate(`/docs/components/${c.slug}`)}
                    >
                      <Component className="size-4 text-muted-foreground" />
                      <div className="flex flex-col">
                        <span>{c.name}</span>
                        <span className="text-xs text-muted-foreground line-clamp-1">
                          {c.description}
                        </span>
                      </div>
                    </CommandItem>
                  ))}
                </CommandGroup>
              )
            },
          )}
        </CommandList>
      </CommandDialog>
    </>
  )
}
