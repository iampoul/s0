import Link from "next/link"

function CodeBlock({ children }: { children: string }) {
  return (
    <pre className="bg-muted/60 border border-border rounded-sm p-4 overflow-x-auto">
      <code className="font-mono text-sm text-foreground">{children}</code>
    </pre>
  )
}

export default function GettingStartedPage() {
  return (
    <article className="max-w-2xl">
      <h1 className="text-3xl font-bold tracking-tight mb-2">Getting Started</h1>
      <p className="text-lg text-muted-foreground mb-10">
        Get S0 components into your SwiftUI project in under a minute.
      </p>

      {/* Prerequisites */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">Prerequisites</h2>
        <ul className="list-disc list-inside space-y-1 text-[15px] text-foreground/90">
          <li>Xcode 15 or later</li>
          <li>iOS 17+ / macOS 14+ deployment target</li>
          <li>A SwiftUI project</li>
        </ul>
      </section>

      {/* Step 1 */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">1. Install the S0 CLI</h2>
        <p className="text-[15px] text-foreground/90 mb-3">
          Clone or download the S0 CLI tool:
        </p>
        <CodeBlock>{`# Using Homebrew
brew install s0-dev/tap/s0

# Or clone and build
git clone https://github.com/s0-dev/s0-cli.git
cd s0-cli && swift build -c release`}</CodeBlock>
      </section>

      {/* Step 2 */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">2. Initialize your theme</h2>
        <p className="text-[15px] text-foreground/90 mb-3">
          Run <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">s0 init</code>{" "}
          in your Xcode project root. This creates the <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">S0Theme.swift</code>{" "}
          file containing all design tokens.
        </p>
        <CodeBlock>{`cd MyApp
s0 init`}</CodeBlock>
      </section>

      {/* Step 3 */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">3. Add components</h2>
        <p className="text-[15px] text-foreground/90 mb-3">
          Use <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">s0 add</code>{" "}
          to copy components into your project. Dependencies are resolved automatically.
        </p>
        <CodeBlock>{`# Add a single component
s0 add button

# Add multiple components
s0 add card input checkbox

# Add all components
s0 add --all`}</CodeBlock>
      </section>

      {/* Step 4 */}
      <section className="mb-10">
        <h2 className="text-xl font-semibold mb-3">4. Use in your views</h2>
        <p className="text-[15px] text-foreground/90 mb-3">
          Every component lives under the <code className="font-mono text-sm bg-muted px-1.5 py-0.5 rounded-sm">S0</code>{" "}
          namespace:
        </p>
        <CodeBlock>{`import SwiftUI

struct ContentView: View {
    @State private var email = ""

    var body: some View {
        VStack(spacing: 16) {
            S0.Input("Email", text: $email, placeholder: "you@example.com")

            S0.Button("Continue", action: {
                print("Submitted: \\(email)")
            })
        }
        .padding()
    }
}`}</CodeBlock>
      </section>

      <div className="flex gap-3">
        <Link
          href="/docs/theming"
          className="inline-flex items-center text-sm text-primary hover:underline"
        >
          Next: Theming →
        </Link>
      </div>
    </article>
  )
}
