---
name: daily-summary
description: Summarize previous business day's work — merged PRs, PRs needing work, and PRs ready for review using Graphite and GitHub CLI
---

## What I Do

Generate a daily work summary by gathering PR status from Graphite (`gt`) and GitHub CLI (`gh`), then categorize and present them in a structured format.

## Steps

### 1. Determine the Lookback Date

Calculate the previous business day (4-day work week, Mon–Thu):
- If today is **Monday**, use **last Thursday's date** (4 days back)
- Otherwise, use **yesterday's date**

Use this as `$SINCE_DATE` in ISO format (YYYY-MM-DD) for filtering.

On macOS:
```bash
if [ "$(date +%u)" -eq 1 ]; then
  SINCE_DATE=$(date -v-4d +%Y-%m-%d)
else
  SINCE_DATE=$(date -v-1d +%Y-%m-%d)
fi
```

### 2. Gather Data

Run these three commands and capture their output:

1. **Open PRs from Graphite:**
   ```bash
   gt log -n 1
   ```
   Parse each PR entry for its title, branch name, PR number, and status indicators (e.g., "needs approval from file owners", "changes requested", "approved", "merged").

2. **Draft PRs from GitHub:**
   ```bash
   gh pr list --author "@me" --draft
   ```
   Returns all your current draft PRs. These are definitively NOT ready for review regardless of any other status.

3. **Recently merged PRs from GitHub:**
   ```bash
   gh pr list --author "@me" --state merged --search "updated:>=$SINCE_DATE"
   ```
   Returns PRs merged since the previous business day.

### 3. Categorize PRs

Place each PR into exactly one category using this logic (evaluated in order):

1. **Merged**: PR appears in the merged PR list (step 2.3), OR `gt log` shows it with a merged status.
2. **Ready for Review**: PR shows "needs approval from file owners" (or similar approval-pending/no-review-yet status) in `gt log` AND is **NOT** found in the draft PR list from step 2.2.
3. **Needs More Work**: Everything else — drafts, PRs with "changes requested", PRs that show "needs approval" but ARE drafts, or PRs still being worked on.

### 4. Format Output

Format the summary using **Slack mrkdwn** (not standard Markdown) so it can be pasted directly into Slack:

- Bold: `*text*` (not `**text**`)
- Italic: `_text_`
- Bullet points: `•` character
- PR links use Slack hyperlink syntax: `https://app.graphite.com/github/pr/pdq/houston/NUMBER` — format as `*PR Title* (https://app.graphite.com/github/pr/pdq/houston/NUMBER)`
- Branch names in backticks: `` `branch-name` ``
- Section headers are bold lines (no `##` prefix)

```
*Daily Work Summary — [Today's Date, e.g. Thursday, March 12, 2026]*
_Looking back to [SINCE_DATE]_

*✅ Merged*
• *PR Title* (https://app.graphite.com/github/pr/pdq/houston/NUMBER) — `branch-name`
• ...

*🚧 Needs More Work*
• *PR Title* (https://app.graphite.com/github/pr/pdq/houston/NUMBER) — `branch-name` — [reason: draft / changes requested / WIP]
• ...

*👀 Ready for Review*
• *PR Title* (https://app.graphite.com/github/pr/pdq/houston/NUMBER) — `branch-name`
• ...
```

If a category has no PRs, include the heading with "None" underneath.

### 5. Write the File

After formatting, write the summary to a local file so it's easy to copy:

- **Path**: `[git repo root]/daily-summary-[YYYY-MM-DD].md` (use today's date)
- To find the repo root, run: `git rev-parse --show-toplevel`
- Write the Slack-formatted content to that file
- Tell the user the file path when done, and remind them to delete it when finished so it doesn't get committed

## Important Rules

- A PR showing "needs approval from file owners" in Graphite is ONLY "Ready for Review" if it is NOT a draft. Always cross-reference with the draft list.
- If `gt log` is not available or errors, fall back to `gh pr list --author "@me"` for open PRs.
- Include PR numbers and branch names for easy reference.
- On weekends or holidays, the user may ask for a different lookback — adjust accordingly if asked.
- Always use Slack mrkdwn format — never standard Markdown.
