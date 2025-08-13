# Wizard Guide

## Overview
- 8-step guided configuration located in `app/views/wizard/steps/step_*.html.erb`
- Shared header at `app/views/wizard/steps/_wizard_header.html.erb`

## Persistence
- Progress stored in `WizardSession` (`current_step`, `step_data`, `status`)
- Selections stored in `ComponentSelection` via associated `Configuration`

## Controllers
- `Wizard::StepsController` handles step navigation and persistence

## Best Practices
- Validate inputs per step; store minimal incremental state
- Use CSS variables and existing classes in `application.css`
- Keep debug elements as requested

