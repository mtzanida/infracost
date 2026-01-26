# Using Copier to Deploy Infracost Across Your Organization

This guide explains how to use [Copier](https://copier.readthedocs.io/) to distribute the Infracost workflow template to multiple repositories in your organization.

## What is Copier?

Copier is a library and CLI tool for rendering project templates. It allows you to create a template repository that can be applied to multiple projects, keeping configurations consistent across your organization.

## Setup Steps

### 1. Install Copier

```bash
pip install copier
# or
pipx install copier
```

### 2. Convert This Repository to a Copier Template

Create a `copier.yml` in the repository root:

```yaml
_templates_suffix: .jinja
_subdirectory: template

_questions:
  organization_name:
    type: str
    help: GitHub organization name
    default: mtzanida

  enable_infracost:
    type: bool
    help: Enable Infracost workflow for cost estimates?
    default: true

  terraform_paths:
    type: str
    help: Paths to Terraform files (comma-separated)
    default: "**.tf,**.tfvars"
```

### 3. Organize Template Files

Create a `template/` directory structure:

```
template/
└── .github/
    └── workflows/
        └── {% if enable_infracost %}infracost.yml{% endif %}
```

### 4. Set Organization-Level Secret

Add `INFRACOST_API_KEY` as an organization secret (one time setup):

1. Go to `https://github.com/organizations/YOUR_ORG/settings/secrets/actions`
2. Click "New organization secret"
3. Name: `INFRACOST_API_KEY`
4. Value: Your Infracost API key
5. Repository access: Select "All repositories" or specific repos

### 5. Apply Template to Repositories

For each repository in your organization:

```bash
# Apply template to a new repository
copier copy gh:mtzanida/infracost /path/to/target-repo

# Update existing repository with template
cd /path/to/target-repo
copier update
```

### 6. Automate with a Script

Create a script to apply across multiple repos:

```bash
#!/bin/bash
# apply-infracost-template.sh

ORG="your-org-name"
TEMPLATE_REPO="gh:mtzanida/infracost"

# Get all repos in organization
REPOS=$(gh repo list $ORG --limit 1000 --json name -q '.[].name')

for REPO in $REPOS; do
  echo "Applying template to $ORG/$REPO..."
  
  # Clone repo
  gh repo clone $ORG/$REPO /tmp/$REPO
  
  # Apply copier template
  copier copy --force $TEMPLATE_REPO /tmp/$REPO
  
  # Commit and push
  cd /tmp/$REPO
  git add .github/workflows/infracost.yml
  git commit -m "Add Infracost workflow from organization template"
  git push
  
  # Cleanup
  cd -
  rm -rf /tmp/$REPO
done
```

## Alternative: GitHub Template Repository

For simpler distribution without Copier:

### 1. Make This a Template Repository

1. Go to repository Settings
2. Check "Template repository"
3. Save

### 2. Organization Members Can Use It

```bash
# Create new repo from template
gh repo create my-new-project --template mtzanida/infracost --public

# Or via GitHub UI: "Use this template" button
```

### 3. For Existing Repositories

Copy the workflow file manually:

```bash
# From any repo in your org
curl -o .github/workflows/infracost.yml \
  https://raw.githubusercontent.com/mtzanida/infracost/main/.github/workflows/infracost.yml

git add .github/workflows/infracost.yml
git commit -m "Add Infracost workflow"
git push
```

## Best Practices

1. **Centralized Secret Management**: Use organization-level secrets instead of repository-level
2. **Version Control**: Tag template versions for controlled rollouts
3. **Documentation**: Keep this guide updated with any workflow changes
4. **Testing**: Test template changes in a sandbox repo first
5. **Notifications**: Inform teams when applying templates to their repos

## Maintenance

To update all repositories when the template changes:

```bash
# With Copier
copier update

# Or re-run the automation script
./apply-infracost-template.sh
```

## Security Notes

- ✅ API key is stored in GitHub Secrets (organization or repository level)
- ✅ Never commit secrets to template repository
- ✅ Use least-privilege permissions in workflows
- ✅ Audit secret access regularly
