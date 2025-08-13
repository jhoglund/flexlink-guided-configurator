# API Guide

Base path: `/api/v1`

## Systems
- `GET /api/v1/systems` — list systems (filters: `category`, `load_capacity`, `system_code`, `search`)
- `GET /api/v1/systems/:system_code` — get one system
- `GET /api/v1/systems/search?q=...` — search systems (filters: `category`, `load_capacity`)
- `GET /api/v1/systems/stats` — summary stats
- `GET /api/v1/systems/overview` — cached overview

## Components
- `GET /api/v1/components` — list components (filters: `component_type`, `system_code`, `min_price`, `max_price`, `search`)
- `GET /api/v1/components/:id` — get one component
- `GET /api/v1/components/search?q=...` — search components (filters: `component_type`, `system_code`, `min_price`, `max_price`)
- `GET /api/v1/components/by_system/:system_code` — components for a system
- `GET /api/v1/components/compatibility` — compatibility matrix

## Images
- `GET /api/v1/images` — product images (filters: `system_code`, `image_type`)
- `GET /api/v1/images/by_system/:system_code` — images for a system

## System Details
- `GET /api/v1/system_details/:system_code` — system with components and images

## Deprecated (for backward compatibility)
- `GET /api/v1/conveyor_systems` → use `/api/v1/systems`
- `GET /api/v1/component_specifications` → use `/api/v1/components`

## Notes
- Auth: public read-only for product data; user endpoints require auth (future)
- Rate limiting recommended at proxy level

