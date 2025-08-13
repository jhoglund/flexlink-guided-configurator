# Data Model

```mermaid
erDiagram
  USERS ||--o{ CONFIGURATIONS : has
  USERS ||--o{ WIZARD_SESSIONS : has
  CONFIGURATIONS ||--o{ COMPONENT_SELECTIONS : has

  USERS {
    string email
    string encrypted_password
    string first_name
    string last_name
    string company
    string phone
  }

  CONFIGURATIONS {
    bigint user_id
    string name
    string status
    jsonb system_specifications
    jsonb selected_components
    jsonb optimization_results
    jsonb wizard_progress
    integer current_step
    decimal total_price
  }

  WIZARD_SESSIONS {
    bigint user_id
    bigint configuration_id
    string session_id
    integer current_step
    jsonb step_data
    jsonb validation_errors
    string status
  }

  COMPONENT_SELECTIONS {
    bigint configuration_id
    string component_type
    string component_id
    string component_name
    jsonb specifications
    jsonb options
    decimal price
    string currency
    integer quantity
    string status
    string system_code
  }
```

## Users
- Authentication via Devise
- Fields: email, encrypted_password, names, company, phone, etc.

## Configurations
- Belongs to `User`
- Fields: name, description, status, `system_specifications` (jsonb), `selected_components` (jsonb), `wizard_progress` (jsonb), `current_step`, `total_price`

## WizardSessions
- Belongs to `User`
- Optional `configuration_id`
- Fields: session_id, current_step, `step_data` (jsonb), `validation_errors` (jsonb), timestamps, status

## ComponentSelections
- Belongs to `Configuration`
- Fields: component_type, component_id, component_name, `specifications` (jsonb), `options` (jsonb), price, currency, quantity, notes, status, selected_at, system_code

## Relationships
- User has many Configurations
- Configuration has many ComponentSelections
- User has many WizardSessions

