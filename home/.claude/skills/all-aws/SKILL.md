---
name: all-aws
description: >-
  Use this skill whenever the user wants to look something up, run a check,
  or execute an AWS CLI command "in all AWS accounts" or "across all
  accounts" without naming specific accounts - or when they invoke
  /all-aws <instructions>. Iterates every locally configured AWS CLI profile
  matching TRAYS-*-PROD-ADMIN and runs the requested command against each,
  grouping results by account. Do NOT use when the user already named
  specific accounts or profiles - use those directly instead.
---

# All-AWS

Run one instruction across every matching AWS account profile and present
the results grouped by account.

## When this applies

- The user asks to "look something up in all AWS accounts" or similar phrasing
  without specifying exact accounts.
- The user runs `/all-aws <instructions>` - `<instructions>` is free text
  describing what to do in every account (a command to run, a resource to
  check, a question to answer).
- If the user explicitly names accounts or profiles instead, use those and
  skip the discovery step below - this skill is only for the "all of them"
  case.

## Process

1. **Discover matching profiles.** Run `aws configure list-profiles` (or
   parse `~/.aws/config`) and filter to profiles matching the pattern
   `TRAYS-*-PROD-ADMIN`.
2. **Translate the instruction into a command once.** Figure out the single
   AWS CLI command (or small sequence) that answers the request, the same
   way you would for a single account.
3. **Run it per profile.** Execute that command once per matching profile,
   passing `--profile <profile_name>` each time. Do not change the command
   between profiles - only the `--profile` flag varies.
4. **Handle failures per-account, not globally.** If a profile fails (e.g.
   expired credentials, access denied), note the failure for that account
   and continue with the remaining profiles - one bad profile must not stop
   the sweep.
5. **Present results grouped by account/profile** so the user can compare
   across accounts at a glance. Call out accounts where the answer differs
   from the rest, and separately list any accounts that failed.

## Notes

- This is a read/inspect pattern by default. If the requested instruction is
  itself a mutating or destructive action (creating, deleting, or modifying
  resources), treat it with the same care as any other risky action -
  confirm scope and blast radius with the user before running it across
  every account, since a mistake here multiplies by account count.
- If the user later says "just these two accounts," narrow to exactly those
  profiles for that request rather than falling back to the full pattern.
