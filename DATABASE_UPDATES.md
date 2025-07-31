# Database Updates and Rails Integration

## Overview

This document describes the major database changes made to the Supabase PostgreSQL database and the corresponding updates to the Rails application to support the new structure.

## Database Changes Summary

### 1. New `systems` Table
- **Replaces:** `conveyor_systems` table
- **Purpose:** Stores comprehensive information about FlexLink conveyor systems
- **Key Features:** 17 FlexLink systems with detailed specifications
- **Data:** X45, XS, X65, X85, XH, X180, X300, XK, XM, XT, XF, XB, XC, XD, XE, XG, CS

### 2. Renamed `components` Table
- **Previous:** `component_specifications`
- **New:** `components`
- **Purpose:** Stores detailed component information for each system
- **Enhancement:** Better compatibility tracking and specifications

### 3. Enhanced Data Structure
- **Product Images:** 300+ extracted images from PDF catalog
- **Views:** System overview, component compatibility, system statistics
- **Functions:** Search systems, get system statistics
- **Indexes:** Performance optimization for common queries

## Rails Application Updates

### New Models

#### System Model (`app/models/system.rb`)
```ruby
# Find systems
System.find_by_system_code('X45')
System.all(category: 'Chain Conveyor')
System.search('chain', load_capacity: 'Medium')

# System relationships
system = System.find_by_system_code('X45')
system.components
system.images
system.full_details
```

#### Component Model (`app/models/component.rb`)
```ruby
# Find components
Component.find(123)
Component.by_type('chain')
Component.by_system('X45')
Component.compatible_with('X45')

# Component details
component = Component.find(123)
component.system
component.price_formatted
component.dimensions_formatted
```

### Updated Models

#### ComponentSelection Model
```ruby
# New system_code field
selection = ComponentSelection.create_from_component(component, configuration)
selection.system
selection.component

# Factory methods
ComponentSelection.create_from_system_components(system, configuration)
```

### New Controllers

#### SystemsController (`app/controllers/systems_controller.rb`)
- **Endpoints:** Index, show, search, by_category, by_load_capacity
- **Features:** Components, images, details, stats, overview
- **URLs:** `/systems`, `/systems/X45`, `/systems/search`

#### Updated API Controller (`app/controllers/api/v1/supabase_controller.rb`)
- **New Endpoints:** Systems, components, product images
- **Enhanced:** Search, filtering, compatibility
- **Legacy:** Backward compatibility maintained

### Updated Services

#### SupabaseService (`app/services/supabase_service.rb`)
```ruby
# New methods
supabase_service.get_systems(filters)
supabase_service.get_system('X45')
supabase_service.search_systems(query, filters)
supabase_service.get_system_with_components('X45')

# Legacy methods (backward compatibility)
supabase_service.get_conveyor_systems(filters)
supabase_service.get_component_specifications(filters)
```

## API Endpoints

### New Systems Endpoints
```
GET /api/v1/systems                    # List all systems
GET /api/v1/systems/search             # Search systems
GET /api/v1/systems/stats              # System statistics
GET /api/v1/systems/overview           # System overview
GET /api/v1/systems/:system_code       # Get specific system
GET /api/v1/systems/:system_code/details    # Full system details
GET /api/v1/systems/:system_code/components # System components
GET /api/v1/systems/:system_code/images     # System images
```

### New Components Endpoints
```
GET /api/v1/components                 # List all components
GET /api/v1/components/search          # Search components
GET /api/v1/components/compatibility   # Component compatibility
GET /api/v1/components/:id             # Get specific component
```

### Legacy Endpoints (Deprecated)
```
GET /api/v1/conveyor_systems           # Use /api/v1/systems
GET /api/v1/component_specifications   # Use /api/v1/components
```

## Routes

### New Routes
```ruby
# Systems management
resources :systems, only: %i[index show] do
  member do
    get 'components'
    get 'images'
    get 'details'
  end
  collection do
    get 'search'
    get 'by_category/:category'
    get 'by_load_capacity/:load_capacity'
    get 'stats'
    get 'overview'
  end
end
```

## Database Migration

### New Migration
```ruby
# db/migrate/20250731134555_add_system_code_to_component_selections.rb
class AddSystemCodeToComponentSelections < ActiveRecord::Migration[8.0]
  def change
    add_column :component_selections, :system_code, :string, limit: 10
    add_index :component_selections, :system_code
  end
end
```

## Usage Examples

### Finding and Using Systems
```ruby
# Find a specific system
system = System.find_by_system_code('X45')
puts system.system_name  # "X45 Chain System"
puts system.load_capacity # "Light duty"

# Get system components
components = system.components
components.each do |component|
  puts "#{component.name}: #{component.price_formatted}"
end

# Get system images
images = system.images
```

### Working with Components
```ruby
# Find components for a system
components = Component.by_system('X45')

# Find compatible components
compatible = Component.compatible_with('X45')

# Get component details
component = Component.find(123)
puts component.price_formatted  # "$150.00"
puts component.dimensions_formatted  # "100 × 50 × 25 mm"
```

### Creating Component Selections
```ruby
# Create from component
component = Component.find(123)
selection = ComponentSelection.create_from_component(component, configuration)

# Create from system components
system = System.find_by_system_code('X45')
selections = ComponentSelection.create_from_system_components(system, configuration)
```

### API Usage
```javascript
// Get all systems
fetch('/api/v1/systems')
  .then(response => response.json())
  .then(data => console.log(data));

// Search systems
fetch('/api/v1/systems/search?q=chain&category=Chain Conveyor')
  .then(response => response.json())
  .then(data => console.log(data));

// Get system details
fetch('/api/v1/systems/X45/details')
  .then(response => response.json())
  .then(data => console.log(data));
```

## Migration Checklist

### Database Migration
1. Run the new migration:
   ```bash
   bin/rails db:migrate
   ```

### Environment Setup
1. Ensure Supabase credentials are configured
2. Test connection to new database structure
3. Verify API endpoints are working

### Testing
1. Test new System model functionality
2. Test new Component model functionality
3. Test API endpoints
4. Test backward compatibility

### Deployment
1. Deploy database migration
2. Update application code
3. Test in staging environment
4. Monitor for any issues

## Backward Compatibility

### Legacy Support
- Old API endpoints still work but return deprecation warnings
- Old table names are redirected to new tables
- Existing code continues to function

### Migration Path
1. Update API calls to use new endpoints
2. Update models to use new structure
3. Remove legacy code when no longer needed

## Performance Considerations

### Caching
- System overview cached for 2 hours
- Component types cached for 6 hours
- System specifications cached for 6 hours

### Indexes
- Added indexes for common queries
- Optimized for system filtering and search
- Prepared for large image dataset

## Security Notes
- Row Level Security (RLS) policies maintained
- API key authentication unchanged
- Data access patterns preserved

## Future Enhancements
- Consider partitioning for large image datasets
- Implement caching for frequently accessed data
- Plan for additional system types and components
- Add real-time updates for system availability 