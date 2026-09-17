# CI Tools Documentation

This project uses GitHub Actions for continuous integration with three main jobs: RSpec tests, RuboCop linting, and security scanning.

## Running CI Tools Locally

### RSpec Tests

Reference `spec/README.md` for detailed Rspec commands

### Security Scanning

#### Brakeman (Static Security Analysis)

```bash
bundle exec brakeman --no-pager
```

Generate a detailed report:

```bash
bundle exec brakeman -o brakeman-report.html
```

#### Bundler Audit (Dependency Vulnerability Scanning)

Update the vulnerability database and check:

```bash
bundle exec bundler-audit --update
bundle exec bundler-audit check
```

## RuboCop Configuration

The project uses a **lenient RuboCop configuration** (`.rubocop.yml`) that focuses on critical issues while being relaxed about style preferences:

- Most style cops are disabled
- Generous line length (120 characters)
- Higher method/class length limits
- Disabled documentation requirements
- Focused on Lint and Security cops

You can adjust the strictness by editing `.rubocop.yml`.

## GitHub Actions Workflow

The CI workflow (`.github/workflows/ci.yml`) runs on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches

All three jobs run in parallel to provide fast feedback.

## Troubleshooting

### RuboCop Cache Issues

If you encounter cache permission errors, RuboCop is configured to use `UseCache: false`. If you want to enable caching locally, you can override this in your local config.

### Security Vulnerabilities

If bundler-audit reports vulnerabilities:
1. Review the reported CVEs
2. Update the affected gems: `bundle update <gem_name>`
3. If no patch is available, consider alternatives or mitigations
