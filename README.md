# Infracost Template

A GitHub template for Terraform projects with automated cost estimation using [Infracost](https://www.infracost.io/).

## Features

- **Automated Cost Estimates**: Infracost workflow comments on PRs with infrastructure cost changes
- **Pre-commit Hooks**: Code quality and consistency checks
- **Secrets Management**: SOPS integration for secure credential handling
- **GitHub Workflows**: CI/CD pipelines and automated labeling

## Quick Start

1. **Use this template** to create a new repository

2. **Set up Infracost**:
   - Get a free API key from [Infracost](https://www.infracost.io/)
   - Add it as a repository secret: `INFRACOST_API_KEY`

3. **Add Terraform files** and create a PR to see cost estimates

## Workflows

- **infracost.yml**: Runs on PRs with Terraform changes, posts cost estimates
- **ci.yml**: Continuous integration for main branch
- **add_labels.yml**: Automated issue and PR labeling

## Managing Secrets with SOPS

### Installation

**macOS:**
```bash
brew install sops
```

**Windows:**
```bash
choco install sops
```

**Linux:**
Download from [sops releases](https://github.com/mozilla/sops/releases)

### Usage

1. **Create a GPG key** (if needed):
   ```bash
   gpg --full-generate-key
   ```

2. **Encrypt secrets**:
   ```bash
   sops --encrypt --gpg your_gpg_key_id secrets.yaml > secrets.enc.yaml
   ```

3. **Decrypt secrets**:
   ```bash
   sops -d secrets.enc.yaml
   ```

4. **Add to .gitignore**:
   ```gitignore
   secrets.yaml
   secrets.enc.yaml
   ```

## Contributing

See [COPIER_SETUP.md](COPIER_SETUP.md) for template setup instructions.

## License

This template is provided as-is for use in your projects.
