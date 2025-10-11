# issue-triage

Intelligent issue classification and triage.

## Usage
```bash
orchestrator github issue-triage [options]
```

## Options
- `--repository <owner/repo>` - Target repository
- `--auto-label` - Automatically apply labels
- `--assign` - Auto-assign to team members

## Examples
```bash
# Triage issues
orchestrator github issue-triage --repository myorg/myrepo

# With auto-labeling
orchestrator github issue-triage --repository myorg/myrepo --auto-label

# Full automation
orchestrator github issue-triage --repository myorg/myrepo --auto-label --assign
```
