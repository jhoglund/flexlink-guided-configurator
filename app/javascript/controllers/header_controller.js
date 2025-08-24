import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropdown", "trigger"]
  
  connect() {
    console.log('🎯 Header controller connected!')
    console.log('🎯 Found triggers:', this.triggerTargets.length)
    console.log('🎯 Found dropdowns:', this.dropdownTargets.length)
    
    this.closeAllDropdowns = this.closeAllDropdowns.bind(this)
    document.addEventListener('click', this.closeAllDropdowns)
  }
  
  disconnect() {
    document.removeEventListener('click', this.closeAllDropdowns)
  }
  
  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    console.log('🎯 Toggle called!')
    
    // Find the dropdown menu within the same nav-dropdown container
    const dropdownContainer = event.currentTarget.closest('.nav-dropdown, .language-dropdown')
    const dropdown = dropdownContainer.querySelector('.dropdown-menu')
    
    const isOpen = dropdown.classList.contains('show')
    
    // Close all other dropdowns first
    this.triggerTargets.forEach(trigger => {
      if (trigger !== event.currentTarget) {
        trigger.setAttribute('aria-expanded', 'false')
        const otherContainer = trigger.closest('.nav-dropdown, .language-dropdown')
        const otherDropdown = otherContainer.querySelector('.dropdown-menu')
        if (otherDropdown) {
          otherDropdown.classList.remove('show')
        }
      }
    })
    
    // Toggle current dropdown
    if (!isOpen) {
      dropdown.classList.add('show')
      event.currentTarget.setAttribute('aria-expanded', 'true')
      
      // Focus first item for keyboard navigation
      const firstItem = dropdown.querySelector('.dropdown-item')
      if (firstItem) {
        firstItem.focus()
      }
    } else {
      dropdown.classList.remove('show')
      event.currentTarget.setAttribute('aria-expanded', 'false')
    }
  }
  
  closeAllDropdowns(event) {
    // Don't close if clicking inside a dropdown
    if (event && this.element.contains(event.target)) {
      return
    }
    
    this.dropdownTargets.forEach(dropdown => {
      dropdown.classList.remove('show')
    })
    
    this.triggerTargets.forEach(trigger => {
      trigger.setAttribute('aria-expanded', 'false')
    })
  }
  
  // Keyboard navigation
  handleKeydown(event) {
    const dropdown = event.currentTarget.closest('.dropdown-menu')
    const items = dropdown.querySelectorAll('.dropdown-item')
    const currentIndex = Array.from(items).indexOf(event.currentTarget)
    
    switch (event.key) {
      case 'ArrowDown':
        event.preventDefault()
        const nextIndex = (currentIndex + 1) % items.length
        items[nextIndex].focus()
        break
        
      case 'ArrowUp':
        event.preventDefault()
        const prevIndex = currentIndex === 0 ? items.length - 1 : currentIndex - 1
        items[prevIndex].focus()
        break
        
      case 'Escape':
        event.preventDefault()
        this.closeAllDropdowns()
        break
        
      case 'Enter':
      case ' ':
        event.preventDefault()
        event.currentTarget.click()
        break
    }
  }
}
