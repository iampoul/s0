import fs from "fs"
import path from "path"
import type { Metadata } from "next"

export const metadata: Metadata = {
  title: "Changelog — S0",
  description: "Release history and updates for the S0 component kit.",
}

function parseChangelog(markdown: string) {
  const lines = markdown.split("\n")
  const releases: { version: string; date: string; url: string; sections: { title: string; items: string[] }[] }[] = []
  let currentRelease: (typeof releases)[0] | null = null
  let currentSection: { title: string; items: string[] } | null = null

  for (const line of lines) {
    // ## [0.2.0](url) — date
    const releaseMatch = line.match(/^## \[(.+?)\]\((.+?)\)\s*[—–-]\s*(.+)/)
    if (releaseMatch) {
      currentRelease = { version: releaseMatch[1], url: releaseMatch[2], date: releaseMatch[3].trim(), sections: [] }
      releases.push(currentRelease)
      currentSection = null
      continue
    }

    // ### Features / Bug Fixes / etc.
    const sectionMatch = line.match(/^### (.+)/)
    if (sectionMatch && currentRelease) {
      currentSection = { title: sectionMatch[1], items: [] }
      currentRelease.sections.push(currentSection)
      continue
    }

    // * Item
    const itemMatch = line.match(/^\* (.+)/)
    if (itemMatch && currentSection) {
      currentSection.items.push(itemMatch[1])
    }
  }

  return releases
}

export default function ChangelogPage() {
  const changelogPath = path.join(process.cwd(), "..", "..", "CHANGELOG.md")
  let content = ""
  try {
    content = fs.readFileSync(changelogPath, "utf-8")
  } catch {
    content = "# Changelog\n\nNo releases yet."
  }

  const releases = parseChangelog(content)

  return (
    <div className="min-h-screen bg-background">
      <div className="mx-auto max-w-3xl px-6 pt-32 pb-20">
        <h1 className="font-sans text-4xl font-bold tracking-tight text-foreground mb-2">
          Changelog
        </h1>
        <p className="text-muted-foreground mb-12">
          Release history and updates for S0.
        </p>

        <div className="space-y-12">
          {releases.map((release) => (
            <article key={release.version} className="relative pl-8 border-l-2 border-border">
              <div className="absolute -left-[9px] top-1 w-4 h-4 rounded-full bg-primary border-4 border-background" />
              <div className="flex items-baseline gap-3 mb-4">
                <a
                  href={release.url}
                  className="font-mono text-xl font-bold text-foreground hover:text-primary transition-colors"
                >
                  v{release.version}
                </a>
                <span className="text-sm text-muted-foreground">{release.date}</span>
              </div>

              {release.sections.map((section) => (
                <div key={section.title} className="mb-4">
                  <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-2">
                    {section.title}
                  </h3>
                  <ul className="space-y-1.5">
                    {section.items.map((item, i) => (
                      <li key={i} className="text-sm text-foreground leading-relaxed flex gap-2">
                        <span className="text-primary mt-1 shrink-0">•</span>
                        <span>{item}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </article>
          ))}
        </div>

        {releases.length === 0 && (
          <p className="text-muted-foreground text-center py-12">No releases yet.</p>
        )}
      </div>
    </div>
  )
}
