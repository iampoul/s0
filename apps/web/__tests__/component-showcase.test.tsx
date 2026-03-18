import { describe, it, expect, vi, afterEach } from 'vitest'
import { render, screen, cleanup } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { ComponentShowcase } from '@/components/landing/component-showcase'

// Mock next/link to render as plain anchor
vi.mock('next/link', () => ({
  default: ({ children, href, ...props }: any) => (
    <a href={href} {...props}>{children}</a>
  ),
}))

afterEach(cleanup)

function getComponentLinks(container: HTMLElement) {
  return Array.from(
    container.querySelectorAll('a[href^="/docs/components/"]')
  ).filter((a) => !a.textContent?.includes('View all'))
}

function getFilterButton(name: string) {
  return screen.getAllByRole('button').find((b) => b.textContent === name)!
}

describe('ComponentShowcase', () => {
  it('renders all 24 components by default', () => {
    const { container } = render(<ComponentShowcase />)
    expect(getComponentLinks(container).length).toBe(24)
  })

  it('renders heading with correct count', () => {
    render(<ComponentShowcase />)
    expect(screen.getAllByText('24 components, ready to use.').length).toBeGreaterThan(0)
  })

  it('renders category filter buttons', () => {
    render(<ComponentShowcase />)
    const buttons = screen.getAllByRole('button')
    const labels = buttons.map((b) => b.textContent)
    expect(labels).toContain('All')
    expect(labels).toContain('Primitives')
    expect(labels).toContain('Forms')
    expect(labels).toContain('Layout')
  })

  it('filters to Primitives when clicked', async () => {
    const user = userEvent.setup()
    const { container } = render(<ComponentShowcase />)
    const primitivesBtn = screen.getAllByRole('button').find((b) => b.textContent === 'Primitives')!
    await user.click(primitivesBtn)

    const links = getComponentLinks(container)
    expect(links.length).toBe(8)
    expect(container.querySelector('a[href="/docs/components/button"]')).toBeTruthy()
    expect(container.querySelector('a[href="/docs/components/badge"]')).toBeTruthy()
  })

  it('filters to Forms when clicked', async () => {
    const user = userEvent.setup()
    const { container } = render(<ComponentShowcase />)
    const formsBtn = screen.getAllByRole('button').find((b) => b.textContent === 'Forms')!
    await user.click(formsBtn)

    const links = getComponentLinks(container)
    expect(links.length).toBe(8)
    expect(container.querySelector('a[href="/docs/components/input"]')).toBeTruthy()
    expect(container.querySelector('a[href="/docs/components/checkbox"]')).toBeTruthy()
  })

  it('filters to Layout when clicked', async () => {
    const user = userEvent.setup()
    const { container } = render(<ComponentShowcase />)
    const layoutBtn = screen.getAllByRole('button').find((b) => b.textContent === 'Layout')!
    await user.click(layoutBtn)

    const links = getComponentLinks(container)
    expect(links.length).toBe(8)
    expect(container.querySelector('a[href="/docs/components/card"]')).toBeTruthy()
    expect(container.querySelector('a[href="/docs/components/tabs"]')).toBeTruthy()
  })

  it('returns to All when clicking All after filter', async () => {
    const user = userEvent.setup()
    const { container } = render(<ComponentShowcase />)
    const buttons = screen.getAllByRole('button')
    const formsBtn = buttons.find((b) => b.textContent === 'Forms')!
    const allBtn = buttons.find((b) => b.textContent === 'All')!

    await user.click(formsBtn)
    await user.click(allBtn)

    expect(getComponentLinks(container).length).toBe(24)
  })

  it('component links point to docs pages', () => {
    const { container } = render(<ComponentShowcase />)
    expect(container.querySelector('a[href="/docs/components/button"]')).toBeTruthy()
    expect(container.querySelector('a[href="/docs/components/card"]')).toBeTruthy()
    expect(container.querySelector('a[href="/docs/components/input"]')).toBeTruthy()
  })

  it('has a "View all components" link', () => {
    const { container } = render(<ComponentShowcase />)
    expect(container.querySelector('a[href="/docs/components"]')).toBeTruthy()
  })
})
