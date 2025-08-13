# Dynamic Breadcrumbs Usage Guide

## Overview

The application now includes a dynamic breadcrumb system that can be easily added to any page. Breadcrumbs are only displayed when the `:breadcrumbs` content block is defined in the view.

## How to Use

### Basic Usage

Add breadcrumbs to any view by including a `content_for :breadcrumbs` block at the top of the view:

```erb
<% content_for :breadcrumbs do %>
  [
    { text: "Home", url: root_path },
    { text: "Systems" }
  ]
<% end %>
```

### Structure

Each breadcrumb item is a hash with:
- `text`: The display text (required)
- `url`: The link URL (optional - omit for current page)

### Examples

#### Home Page (No breadcrumbs needed)
The home page doesn't need breadcrumbs, but if you want to show it:

```erb
<% content_for :breadcrumbs do %>
  [
    { text: "Home" }
  ]
<% end %>
```

#### Systems Page
```erb
<% content_for :breadcrumbs do %>
  [
    { text: "Home", url: root_path },
    { text: "Systems" }
  ]
<% end %>
```

#### Product Detail Page
```erb
<% content_for :breadcrumbs do %>
  [
    { text: "Home", url: root_path },
    { text: "Products", url: products_path },
    { text: @product[:name] }
  ]
<% end %>
```

#### Wizard Step Page
```erb
<% content_for :breadcrumbs do %>
  [
    { text: "Home", url: root_path },
    { text: "System Builder", url: wizard_steps_path },
    { text: "Step #{@current_step}" }
  ]
<% end %>
```

## Features

- **Automatic styling**: Breadcrumbs are styled consistently across the application
- **Clickable links**: All items except the last one are clickable links
- **Current page indication**: The last item is styled differently to show it's the current page
- **Conditional display**: Breadcrumbs only appear when the content block is defined
- **Responsive design**: Works on all screen sizes

## Styling

The breadcrumbs use the following styling:
- Background: Light gray (`var(--gray-50)`)
- Border: Bottom border (`var(--gray-200)`)
- Text: Gray (`var(--gray-500)`)
- Current page: Darker gray (`var(--gray-700)`) with medium font weight
- Separators: Light gray (`var(--gray-400)`)

## Implementation Details

The breadcrumb system is implemented in `app/helpers/application_helper.rb` with the `breadcrumbs` helper method. It uses Rails' `content_for` and `content_tag` helpers to generate the HTML dynamically. 