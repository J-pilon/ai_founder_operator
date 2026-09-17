# AI Founder Operator - Project Context

## Project Overview

This API accepts business-related questions, initially via SMS, and uses AI to provide accurate, useful insights into business operations. Its goal is to help the founder quickly understand business performance and identify the highest-priority items without manually searching for the information.

## Technical Stack

- **Framework**: Ruby on Rails 7.0.3 (API-only mode)
- **Ruby Version**: 3.1.3
- **Database**: SQLite3
- **SMS Integration**: Twilio Ruby SDK (7.11.2)
- **Testing**: RSpec
- **Web Server**: Puma

## Application Architecture

### API-Only Rails Application

This is a Rails API application (`config.api_only = true`), meaning:
- No views, helpers, or asset pipeline
- Lighter middleware stack
- Focused on JSON responses
- Designed for programmatic consumption

### Core Functionality

1. **SMS Interface**: Receives business questions via SMS through Twilio
2. **AI Processing**: Processes questions using AI to extract insights from business data
3. **Response Delivery**: Returns concise, actionable insights back to the founder

## Key Business Context

- **Target User**: Founder/business owner who needs quick insights
- **Use Case**: On-the-go business performance queries without manual data hunting
- **Priority**: Accuracy and usefulness of insights over speed
- **Interface**: Primarily SMS-based for maximum accessibility

## Development Principles

- Keep responses concise and actionable
- Prioritize accuracy in business insights
- Design for mobile/SMS consumption patterns
- Focus on high-priority business metrics

## Shipping Code Conventions

Reference `docs/git-conventions.md` for commit conventions.
