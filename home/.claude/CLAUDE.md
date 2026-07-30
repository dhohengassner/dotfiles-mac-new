## Formatting Rules

- Always use the standard hyphen-minus character `-` (U+002D) for dashes. Never use em dashes (—), en dashes (–), or any other Unicode dash characters.

## AWS Multi-Account Lookup

- When I ask to "look something up in all AWS accounts" or similar phrasing without specifying exact accounts, default to iterating through all locally configured AWS CLI profiles matching the pattern `TRAYS-*-PROD-ADMIN`.
- Use `aws configure list-profiles` or parse `~/.aws/config` to discover all matching profiles.
- For each matching profile, run the requested command/query using `--profile <profile_name>`.
- Collect and present results grouped by account/profile for easy comparison.
- If a profile fails (e.g., expired credentials), note the failure and continue with the remaining profiles.
- If I explicitly specify accounts or profiles, use those instead of the default pattern.
