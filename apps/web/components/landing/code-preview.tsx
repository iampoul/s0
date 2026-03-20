"use client"

import { useState } from "react"
import { Copy, Check } from "lucide-react"

const K = ({ children }: { children: React.ReactNode }) => (
  <span style={{ color: "#f24c00" }}>{children}</span>
)
const T = ({ children }: { children: React.ReactNode }) => (
  <span style={{ color: "#9cdcfe" }}>{children}</span>
)
const C = ({ children }: { children: React.ReactNode }) => (
  <span style={{ color: "#f59060" }}>{children}</span>
)
const S = ({ children }: { children: React.ReactNode }) => (
  <span style={{ color: "#8a9290" }}>{children}</span>
)

type Line = React.ReactNode

const codeLines: Line[] = [
  <><K>import</K> S0</>,
  <></>,
  <><K>struct</K> <T>ProfileCard</T>: <T>View</T> {"{"}</>,
  <>{"  "}<K>@State</K> <K>private var</K> name = <S>""</S></>,
  <>{"  "}<K>@State</K> <K>private var</K> notify = <K>true</K></>,
  <></>,
  <>{"  "}<K>var</K> body: <K>some</K> <T>View</T> {"{"}</>,
  <>{"    "}<C>S0.Card</C> {"{"}</>,
  <>{"      "}<T>VStack</T>(<S>spacing:</S> <C>S0.Theme.Spacing.md</C>) {"{"}</>,
  <>{"        "}<C>S0.Avatar</C>(<S>initials:</S> <S>"JD"</S>, <S>size:</S> <S>.lg</S>)</>,
  <>{"        "}<C>S0.Input</C>(<S>"Name"</S>, <S>text:</S> <S>$name</S>,</>,
  <>{"               "}<S>placeholder:</S> <S>"Your name"</S>)</>,
  <>{"        "}<C>S0.Toggle</C>(<S>"Notifications"</S>, <S>isOn:</S> <S>$notify</S>)</>,
  <>{"        "}<C>S0.Button</C>(<S>"Save Profile"</S>) {"{"}</>,
  <>{"          "}<S>// Save action</S></>,
  <>{"        "}{"}"}</>,
  <>{"      "}{"}"}</>,
  <>{"    "}{"}"}</>,
  <>{"  "}{"}"}</>,
  <>{"}"}</>,
]

const codeString = `import S0

struct ProfileCard: View {
    @State private var name = ""
    @State private var notify = true

    var body: some View {
        S0.Card {
            VStack(spacing: S0.Theme.Spacing.md) {
                S0.Avatar(initials: "JD", size: .lg)
                S0.Input("Name", text: $name,
                         placeholder: "Your name")
                S0.Toggle("Notifications", isOn: $notify)
                S0.Button("Save Profile") {
                    // Save action
                }
            }
        }
    }
}`

export function CodePreview() {
  const [copied, setCopied] = useState(false)

  const handleCopy = () => {
    navigator.clipboard.writeText(codeString)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <section className="py-20 px-6">
      <div className="mx-auto max-w-6xl">
        <div className="grid md:grid-cols-2 gap-0 border border-border overflow-hidden">
          {/* Left: description */}
          <div className="flex flex-col justify-center p-10 bg-card border-r border-border">
            <p className="font-mono text-xs text-primary uppercase tracking-widest mb-4">Swift · SwiftUI</p>
            <h2 className="text-3xl md:text-4xl font-bold tracking-tight text-foreground mb-4 text-balance">
              Write less.<br />Ship more.
            </h2>
            <p className="text-muted-foreground leading-relaxed mb-8">
              Every S0 component is designed with sensible defaults and a composable API.
              No boilerplate. No configuration files. Just import and use.
            </p>
            <div className="flex flex-col gap-3">
              {[
                "Fully typed Swift API",
                "Adaptive dark & light mode",
                "Accessibility built-in",
                "SwiftUI previews included",
              ].map((item) => (
                <div key={item} className="flex items-center gap-3">
                  <span className="w-1 h-1 rounded-full bg-primary flex-shrink-0" />
                  <span className="text-sm text-muted-foreground">{item}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Right: code block */}
          <div className="bg-background flex flex-col">
            {/* Tab bar */}
            <div className="flex items-center justify-between px-4 py-2 border-b border-border bg-card/50">
              <div className="flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-border" />
                <span className="w-2.5 h-2.5 rounded-full bg-border" />
                <span className="w-2.5 h-2.5 rounded-full bg-border" />
              </div>
              <span className="font-mono text-xs text-muted-foreground">ProfileCard.swift</span>
              <button
                onClick={handleCopy}
                className="flex items-center gap-1.5 text-muted-foreground hover:text-foreground transition-colors"
                aria-label="Copy code"
              >
                {copied ? <Check size={13} className="text-primary" /> : <Copy size={13} />}
                <span className="text-xs font-mono">{copied ? "Copied" : "Copy"}</span>
              </button>
            </div>

            {/* Code — static JSX tokens, no dangerouslySetInnerHTML */}
            <div className="overflow-x-auto p-5 flex-1">
              <pre className="font-mono text-xs leading-6 text-muted-foreground">
                {codeLines.map((line, i) => (
                  <div key={i} className="flex gap-4">
                    <span className="select-none w-4 text-right text-border flex-shrink-0">{i + 1}</span>
                    <span>{line}</span>
                  </div>
                ))}
              </pre>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
