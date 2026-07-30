## Formatting Rules

- CRITICAL: Never type an em dash (—) or en dash (–) in any output - chat replies, code, comments, commit messages, documents, artifacts, everything. This is a hard rule, not a style preference.
- Use the standard hyphen-minus `-` (U+002D) for a dash. If a sentence was reaching for an em dash to set off a clause, either use " - " with spaces (like this), or restructure with a comma, colon, period, or "and"/"but" - don't just swap the character and keep the same sentence shape if a comma reads more naturally.
- Before finishing any response, scan what you're about to output for — and – and fix any that slipped in. This character is a strong default in your training data, so it takes a deliberate check, not just awareness of the rule.

## AWS Multi-Account Lookup

- When I ask to "look something up in all AWS accounts" or similar phrasing without specifying exact accounts, default to iterating through all locally configured AWS CLI profiles matching the pattern `TRAYS-*-PROD-ADMIN`.
- Use `aws configure list-profiles` or parse `~/.aws/config` to discover all matching profiles.
- For each matching profile, run the requested command/query using `--profile <profile_name>`.
- Collect and present results grouped by account/profile for easy comparison.
- If a profile fails (e.g., expired credentials), note the failure and continue with the remaining profiles.
- If I explicitly specify accounts or profiles, use those instead of the default pattern.
