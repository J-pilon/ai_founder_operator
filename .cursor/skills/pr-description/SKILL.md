---
name: pr-description
description: Generate pull request descriptions following the project's standard format. Use when writing PR descriptions, creating pull requests, or when the user asks to write or format a PR description.
---

# PR Description Generator

Generate pull request descriptions using the standard format for this project.

## Required Structure

Every PR description must follow this exact format:

### Summary:
Provide a concise summary of what changed and why.

### Changes:
Describe what the changes were, such as what file was changed and what the changes were. Use bulletpoint formatting.

### Concerns:
This section must contain a list of concerns regarding the changes, such as security vulnerabilities, performance issues, edge cases, architectural concerns, etc. If there are no concerns then this section should say: "No concerns identified".

### Resources:
List any external resources that pertain to this PR such as images, design docs, etc. Include internal documentation from the `docs/` directory (plans, designs).

---

## Guidelines

### Summary Section
- Keep it to 2-3 sentences
- Start with the "what" then explain the "why"
- Focus on business value or problem being solved
- Be specific about the feature or fix

### Changes Section
- Use bullet points for each logical change
- Group related changes together
- Mention specific files or components when relevant
- Include both code and test changes

### Concerns Section
- Think critically about potential issues
- Consider: security, performance, edge cases, architecture, backwards compatibility
- Be honest - list real concerns, not hypotheticals
- If genuinely no concerns exist, state: "No concerns identified"
- Better to flag potential issues than miss them

### Resources Section
- Link to internal plans docs in `docs/` directory
- Link to internal design docs in `docs/` directory
- Link to design documents, Figma files, or specs
- Include screenshots or videos if relevant
- Reference related issues or tickets
- Link to any external documentation used

---

## Example PR Description

```markdown
Summary:
Added SMS webhook endpoint to receive and process business questions from Twilio. This enables founders to text questions about their business and receive AI-generated insights. The endpoint validates Twilio signatures and queues messages for async processing.

Changes:
- Added `SmsController#receive` endpoint at POST /sms/receive
- Created `ProcessBusinessQuestionJob` to handle async AI processing
- Added Twilio signature validation in `TwilioAuthenticator` service
- Added request specs for SMS webhook scenarios
- Updated routes to include SMS endpoints

Concerns:
- SMS endpoint is publicly accessible - ensure Twilio signature validation is always enabled
- No rate limiting yet - could be vulnerable to abuse if Twilio credentials compromised
- Error responses might leak internal information - review error messages

Resources:
- Internal design: docs/designs/sms-webhook-design.md
- Internal plan: docs/plans/ai-integration-plan.md
- Twilio webhook documentation: https://www.twilio.com/docs/usage/webhooks
```

---

## Workflow

1. **Review the changes**: Read through the git diff or changed files
2. **Draft the summary**: Start with what changed and why it matters
3. **List the changes**: Go through each file and describe modifications
4. **Identify concerns**: Think critically about risks and edge cases
5. **Add resources**: Include any relevant links or references
6. **Review**: Ensure all sections are complete and accurate
