import { describe, it, expect } from 'vitest'
import {
  components,
  categories,
  getComponentBySlug,
  getComponentsByCategory,
  sidebarNav,
  type ComponentDoc,
} from '@/lib/docs-data'

describe('docs-data', () => {
  describe('components', () => {
    it('exports 32 components', () => {
      expect(components).toHaveLength(32)
    })

    it('every component has required fields', () => {
      for (const comp of components) {
        expect(comp.name).toBeTruthy()
        expect(comp.slug).toBeTruthy()
        expect(comp.description).toBeTruthy()
        expect(comp.category).toBeTruthy()
        expect(comp.usage.length).toBeGreaterThan(0)
        expect(comp.props.length).toBeGreaterThan(0)
      }
    })

    it('slugs are unique', () => {
      const slugs = components.map((c) => c.slug)
      expect(new Set(slugs).size).toBe(slugs.length)
    })

    it('all categories are valid', () => {
      const validCategories = Object.keys(categories)
      for (const comp of components) {
        expect(validCategories).toContain(comp.category)
      }
    })

    it('props have name, type, and description', () => {
      for (const comp of components) {
        for (const prop of comp.props) {
          expect(prop.name).toBeTruthy()
          expect(prop.type).toBeTruthy()
          expect(prop.description).toBeTruthy()
        }
      }
    })
  })

  describe('getComponentBySlug', () => {
    it('returns component for valid slug', () => {
      const button = getComponentBySlug('button')
      expect(button).toBeDefined()
      expect(button!.name).toBe('Button')
      expect(button!.category).toBe('primitives')
    })

    it('returns undefined for unknown slug', () => {
      expect(getComponentBySlug('nonexistent')).toBeUndefined()
    })

    it('finds every component by its slug', () => {
      for (const comp of components) {
        expect(getComponentBySlug(comp.slug)).toBe(comp)
      }
    })
  })

  describe('getComponentsByCategory', () => {
    it('returns primitives', () => {
      const primitives = getComponentsByCategory('primitives')
      expect(primitives.length).toBeGreaterThan(0)
      expect(primitives.every((c) => c.category === 'primitives')).toBe(true)
    })

    it('returns forms', () => {
      const forms = getComponentsByCategory('forms')
      expect(forms.length).toBeGreaterThan(0)
      expect(forms.every((c) => c.category === 'forms')).toBe(true)
    })

    it('returns layout', () => {
      const layout = getComponentsByCategory('layout')
      expect(layout.length).toBeGreaterThan(0)
      expect(layout.every((c) => c.category === 'layout')).toBe(true)
    })

    it('all components belong to a category', () => {
      const all = [
        ...getComponentsByCategory('primitives'),
        ...getComponentsByCategory('forms'),
        ...getComponentsByCategory('layout'),
      ]
      expect(all.length).toBe(components.length)
    })
  })

  describe('sidebarNav', () => {
    it('has getting started links', () => {
      expect(sidebarNav.gettingStarted.length).toBeGreaterThan(0)
      for (const link of sidebarNav.gettingStarted) {
        expect(link.title).toBeTruthy()
        expect(link.href).toMatch(/^\/docs/)
      }
    })

    it('has component links for each category', () => {
      expect(sidebarNav.components.primitives.length).toBeGreaterThan(0)
      expect(sidebarNav.components.forms.length).toBeGreaterThan(0)
      expect(sidebarNav.components.layout.length).toBeGreaterThan(0)
    })

    it('component links point to /docs/components/', () => {
      const allLinks = [
        ...sidebarNav.components.primitives,
        ...sidebarNav.components.forms,
        ...sidebarNav.components.layout,
      ]
      for (const link of allLinks) {
        expect(link.href).toMatch(/^\/docs\/components\//)
        expect(link.title).toBeTruthy()
      }
    })

    it('sidebar has a link for every component', () => {
      const allLinks = [
        ...sidebarNav.components.primitives,
        ...sidebarNav.components.forms,
        ...sidebarNav.components.layout,
      ]
      expect(allLinks.length).toBe(components.length)
    })
  })

  describe('categories', () => {
    it('has three categories', () => {
      expect(Object.keys(categories)).toEqual(['primitives', 'forms', 'layout'])
    })

    it('has human-readable labels', () => {
      expect(categories.primitives).toBe('Primitives')
      expect(categories.forms).toBe('Forms')
      expect(categories.layout).toBe('Layout')
    })
  })
})
