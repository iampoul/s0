export function Footer() {
  return (
    <footer className="border-t border-border px-6 py-10">
      <div className="mx-auto max-w-6xl flex flex-col md:flex-row items-start md:items-center justify-between gap-8">
        {/* Brand */}
        <div>
          <div className="font-mono text-base font-bold text-foreground mb-1">
            S<span className="text-primary">0</span>
          </div>
          <p className="text-xs text-muted-foreground">
            The zero-friction SwiftUI component kit.
          </p>
        </div>

        {/* Links */}
        <div className="flex flex-wrap gap-x-8 gap-y-3">
          {[
            { label: "Components", href: "#" },
            { label: "Documentation", href: "#" },
            { label: "Changelog", href: "#" },
            { label: "GitHub", href: "#" },
            { label: "License", href: "#" },
          ].map(({ label, href }) => (
            <a
              key={label}
              href={href}
              className="text-xs text-muted-foreground hover:text-foreground transition-colors duration-200"
            >
              {label}
            </a>
          ))}
        </div>

        {/* Copyright */}
        <p className="text-xs text-muted-foreground font-mono">
          © 2026 S0 Kit
        </p>
      </div>
    </footer>
  )
}
