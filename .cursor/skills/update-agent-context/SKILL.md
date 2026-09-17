---
name: update-agent-context
description: Update the AGENT.md file with project-level context following conciseness principles. Use when modifying AGENT.md, adding project context, updating architecture documentation, or when the user asks to update project context or the AGENT file.
---

# Update AGENT.md Context File

## Critical Principle: Conciseness is Mandatory

The `AGENT.md` file is **passed with every single prompt** to the AI. Every token in this file competes with conversation history and code context in the context window. Therefore, **conciseness is not optional—it's required**.

## What Belongs in AGENT.md

AGENT.md is **exclusively for project-level context** that:

1. **Is specific to THIS application** (not general knowledge)
2. **Remains relatively stable** (not frequently changing implementation details)
3. **Affects multiple parts of the codebase** (not isolated features)
4. **Cannot be easily inferred** from reading the code

### Include These Categories:

- **Project purpose and goals**: What problem does this solve? Who is it for?
- **High-level architecture**: API-only? Microservices? Key architectural decisions?
- **Core functionality**: The 3-5 main things this application does
- **Technical stack**: Framework, language versions, major dependencies
- **Key business context**: Domain-specific knowledge needed to understand the code
- **Explicitly out of scope**: What this application intentionally does NOT do
- **Critical constraints**: Performance requirements, regulatory requirements, technical limitations

### Do NOT Include:

- ❌ General programming knowledge or framework documentation
- ❌ Detailed implementation instructions (those belong in code comments or separate docs)
- ❌ Frequently changing feature details (those belong in tickets/issues)
- ❌ API documentation (use OpenAPI/Swagger for that)
- ❌ Deployment procedures (those belong in deployment docs)
- ❌ Team processes or workflows (those belong in team wikis)
- ❌ Changelog or version history (use git history)
- ❌ Setup instructions (those belong in README.md)

## Conciseness Guidelines

When updating AGENT.md:

1. **Challenge every sentence**: "Does the AI really need this to understand the project?"
2. **Use bullet points** over paragraphs when possible
3. **Remove redundancy**: If it's in the code or config, don't repeat it
4. **Prefer specifics over generalities**: "SMS-based business insights" not "provides various features"
5. **Target length**: Aim for 50-100 lines total. Going over 150 lines requires strong justification.

### Good Example (Concise):
```markdown
## Core Functionality

1. **SMS Interface**: Receives business questions via Twilio
2. **AI Processing**: Extracts insights from business data
3. **Response Delivery**: Returns concise answers via SMS
```

### Bad Example (Verbose):
```markdown
## Core Functionality

The application provides a comprehensive set of features designed to help business owners
get the information they need. It starts by receiving messages through SMS using the Twilio
platform, which is a cloud communications platform that enables developers to build SMS
applications. Then it processes these messages using AI technology to understand what the
user is asking about...
```

## Update Workflow

When updating AGENT.md:

1. **Identify the change**: What project-level context needs to be added/updated/removed?
2. **Verify it belongs**: Does it meet the "What Belongs" criteria above?
3. **Write concisely**: Draft the update using minimal words
4. **Review for redundancy**: Is this information already elsewhere in the file?
5. **Check total length**: Keep the entire file under 150 lines if possible
6. **Preserve structure**: Maintain consistent heading hierarchy and organization

## When to Update AGENT.md

Update AGENT.md when:

- ✅ Core architecture changes (e.g., switching from monolith to microservices)
- ✅ Project purpose evolves (e.g., adding new primary user types)
- ✅ Major technical stack changes (e.g., framework upgrade with breaking changes)
- ✅ Key business context emerges (e.g., regulatory compliance requirements)
- ✅ Scope boundaries change (e.g., explicitly deciding NOT to support a feature)

Do NOT update AGENT.md for:

- ❌ Adding new features (unless they fundamentally change the project purpose)
- ❌ Bug fixes or refactoring (unless they reveal misunderstood architecture)
- ❌ Dependency version bumps (unless they change how the app works)
- ❌ Team process changes (those don't affect code understanding)

## Remember

Every word in AGENT.md has a cost—it takes up context window space in every conversation. Make each word earn its place by providing essential project context that cannot be obtained any other way.
