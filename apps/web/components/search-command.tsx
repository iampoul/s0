"use client"

import * as React from "react"
import { useRouter } from "next/navigation"
import { FileText, Palette, Search, BookOpen, Component } from "lucide-react"
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
} from "@/components/ui/command"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { components, categories, sidebarNav } from "@/lib/docs-data"

export function SearchCommand() {
  const router = useRouter()
  const [open, setOpen] = React.useState(false)

  React.useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        if (
          (e.target instanceof HTMLElement && e.target.isContentEditable) ||
          e.target instanceof HTMLInputElement ||
          e.target instanceof HTMLTextAreaElement ||
          e.target instanceof HTMLSelectElement
        ) {
          return
        }
        e.preventDefault()
        setOpen((prev) => !prev)
      }
    }
    document.addEventListener("keydown", onKeyDown)
    return () => document.removeEventListener("keydown", onKeyDown)
  }, [])

  const runCommand = React.useCallback(
    (command: () => unknown) => {
      setOpen(false)
      command()
    },
    [],
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

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogHeader className="sr-only">
          <DialogTitle>Search documentation</DialogTitle>
          <DialogDescription>Search components, guides, and pages</DialogDescription>
        </DialogHeader>
        <DialogContent className="overflow-hidden p-0" showCloseButton={false}>
          <Command className="[&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group]]:px-2 [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3">
            <CommandInput placeholder="Search components, docs..." />
            <CommandList>
              <CommandEmpty>No results found.</CommandEmpty>

              <CommandGroup heading="Getting Started">
                {sidebarNav.gettingStarted.map((item) => (
                  <CommandItem
                    key={item.href}
                    value={item.title}
                    onSelect={() => runCommand(() => router.push(item.href))}
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
                  onSelect={() => runCommand(() => router.push("/themes"))}
                >
                  <Palette className="size-4 text-muted-foreground" />
                  <span>Themes</span>
                </CommandItem>
                <CommandItem
                  value="Changelog"
                  onSelect={() => runCommand(() => router.push("/changelog"))}
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
                          onSelect={() =>
                            runCommand(() =>
                              router.push(`/docs/components/${c.slug}`)
                            )
                          }
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
          </Command>
        </DialogContent>
      </Dialog>
    </>
  )
}
