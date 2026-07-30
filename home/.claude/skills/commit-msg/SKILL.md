---
name: commit-msg
description: >-
  Use this skill whenever the user wants to write, draft, or fix a git commit
  message - including requests like "commit this", "write a commit message",
  "what should I commit", or staging changes that need a message. Produces
  messages that ALWAYS start with a gitmoji and otherwise follow the
  Conventional Commits v1.0.0 specification. Do NOT use for changelog
  generation, release notes, or PR descriptions unless they explicitly reuse
  this commit format.
---

# Commit

## Scope - message only, never actions

This skill drafts a commit message. That is the entire job.

- **Never run `git commit`.** Write the message to a file for the user to use  
  themselves - even if they say "commit this." "Commit this" means "write the  
  message for this," not "run the command."
- **Never create, switch, or check out a branch.** No `git branch`,  
  `git checkout -b`, `git switch -c`, or similar.
- **Never stage files** (`git add`) as part of this skill. Reading the diff  
  (`git diff`, `git status`, `git diff --staged`) to see what changed is fine -  
  that's inspection, not action.
- If the user explicitly asks you to *also* commit or branch, that is a  
  separate request outside this skill - handle it after, and only with the  
  same confirmation you'd want before any git action that changes repo state.

## Where the message goes - always `commit_msg.md` at the repo root

Always write the final message with the Write tool to `commit_msg.md` at the  
repo's top level - find it with `git rev-parse --show-toplevel` and join  
`commit_msg.md` to that path. This is the only destination.

- **Never** write it to `/tmp`, the session scratchpad directory, `.claude/`,  
  or any other path - even though the scratchpad is where you'd normally put  
  throwaway output, this file is the deliverable and belongs in the repo.
- If `commit_msg.md` already exists at the repo root, overwrite it - it's  
  meant to hold the *current* message, not a history of past ones.
- After writing, tell the user the file was written (state the path) and show  
  the message inline too, so they don't have to open the file to see it.
- This file is a working artifact, not something to `git add` - leave it  
  untracked/unstaged. If the repo has a `.gitignore`, you may mention that the  
  user might want to add `commit_msg.md` to it, but don't edit `.gitignore`  
  yourself unless asked.

Write every commit message in this exact shape.

The gitmoji is mandatory and always comes first.  
Everything after it follows Conventional Commits v1.0.0.

## Format

```
<gitmoji> <type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

A real example (each sentence is its own line, ending in two trailing  
spaces - invisible above, shown as `·` here: `…feature flag.·· / The flag…`).  
The blank line before the second paragraph marks a different idea:

```
✨ feat(auth): add OAuth2 login flow

Add Google and GitHub providers behind a feature flag.  
The flag defaults to off so existing sessions are untouched.

Login state now persists across browser restarts.

Task: https://redbull-gms.atlassian.net/browse/MITCESQ-2558
Reviewed-by: Dana Lee
```

## Rules

These are non-negotiable. Read them before writing anything.

1. **Start with a gitmoji.**  
  Use the unicode emoji (✨), not the shortcode (`:sparkles:`),  
  unless the user's tooling needs shortcodes - then ask or match their history.

2. **One space** between the gitmoji and the type.

3. **Type is required** and is a lowercase noun: `feat`, `fix`, `docs`, etc.  
  See the table below for the canonical set.

4. **Scope is optional** and goes in parentheses right after the type: `fix(parser):`.  
  Use a short noun for the affected area (a module, package, or surface).

5. **`!` marks a breaking change** and goes immediately before the colon:  
  `feat(api)!:` - see the Breaking changes section.

6. **A colon and a single space** separate the prefix from the description.

7. **Description** is a short summary in the imperative mood, lowercase, no trailing period.  
  Good: `add retry logic`.  Bad: `Added retry logic.`  
  Aim for ~50 characters, but treat it as a soft target, not a hard cap.  
  If a whole idea reads more naturally and lands within ±10 characters  
  (so up to ~60), keep it intact rather than truncating or abbreviating.  
  Don't pad a short description to hit the number either - shorter is fine.

8. **Body is optional.**  
  It starts one blank line after the description.  
  Explain *what* and *why*, not *how*.

  **Every new sentence starts on a new line - always.**  
  End each line with **two trailing spaces** - Markdown's hard line break,  
  which GitLab renders as `<br>`. This applies to *every* sentence, including  
  the last one in a paragraph (yes, even though a blank line follows it). A  
  bare newline (no trailing spaces) collapses into a space and the text  
  reflows into one block, which is why unwrapped commits looked wrong.

  **Long sentences still wrap - don't ignore the limit.**  
  ~72 columns is the target. You may overrun to finish a word or clause  
  cleanly, but never by more than ~10 characters (so ~82 is the hard ceiling).  
  When a sentence is longer than that, hard-break it at a natural point  
  (end each broken line with two trailing spaces) and continue the same  
  sentence on the next line. One sentence per line is the goal, but a single  
  sentence must never run as one giant 100+ char line - wrap it.

  **Blank lines separate different ideas (new paragraph / abstract).**  
  When the next sentence is a *different* idea, change, or explanation, put  
  an empty line before it to start a new paragraph. Sentences that belong to  
  the same idea stay together (one per line) within the paragraph.

  Caveat: some editors, `.editorconfig` (`trim_trailing_whitespace`),  
  linters (markdownlint MD009), and `git` settings strip trailing  
  whitespace. If yours does, either disable it for commit messages or  
  fall back to one unbroken line per paragraph (also renders correctly).

9. **Footers are optional.**  
  They start one blank line after the body.  
  Each footer is `Token: value` or `Token #value`.  
  Tokens use `-` instead of spaces (e.g. `Reviewed-by`),  
  the one exception being `BREAKING CHANGE`.  
  Keep each footer on a single line (token and value together) for the  
  same newline reason as the body - one footer per line.

10. **Never add AI attribution.**  
  Do not append `Co-Authored-By: Claude`, `Co-Authored-By: Opus`,  
  "Generated with Claude Code", or any similar AI-authorship line or footer.  
  The commit is the user's. Leave attribution out entirely.

## Type → gitmoji quick reference

Pick the type first, then the gitmoji that best fits the *intent* of the change.  
Several gitmoji can map to one type - choose the most specific.

| Type       | Meaning                                   | Common gitmoji            |
|------------|-------------------------------------------|---------------------------|
| `feat`     | A new feature (MINOR in semver)           | ✨ 🎉 🚩 💫               |
| `fix`      | A bug fix (PATCH in semver)               | 🐛 🚑️ 🩹 🔒️ 🥅          |
| `docs`     | Documentation only                        | 📝 💡 📄                  |
| `style`    | Formatting, whitespace, no logic change   | 🎨 💄 🚨                  |
| `refactor` | Code change that isn't a feature or fix   | ♻️ 🏗️ ⚰️ 🚚              |
| `perf`     | Performance improvement                   | ⚡️                       |
| `test`     | Adding or fixing tests                    | ✅ 🧪 📸                  |
| `build`    | Build system or dependencies              | 📦️ ➕ ➖ ⬆️ ⬇️ 📌        |
| `ci`       | CI configuration and scripts              | 👷 💚                     |
| `chore`    | Maintenance, tooling, config              | 🔧 🔨 🙈 🏷️              |
| `revert`   | Reverting a previous commit               | ⏪️                       |

If nothing fits cleanly, prefer `chore` with the closest gitmoji  
rather than inventing a new type.

## Breaking changes

A breaking change MUST be signalled in one of two ways (you can use both).

**In the prefix** - add `!` before the colon:

```
💥 feat(api)!: drop support for v1 endpoints
```

**In the footer** - add a `BREAKING CHANGE:` entry (uppercase, with a colon):

```
💥 feat(api): migrate to v2 schema

BREAKING CHANGE: the `/users` payload now nests under `data`. Clients reading the top-level array will break.
```

`BREAKING-CHANGE` (hyphenated) is synonymous with `BREAKING CHANGE`.  
The words must stay uppercase - everything else in the message is case-insensitive.

## Worked examples

A minimal fix:

```
🐛 fix: prevent crash on empty config
```

A scoped feature with a body (note the trailing spaces on *every* line,  
including the last):

```
✨ feat(cart): support saving items for later

Persist the saved list per user so it survives logout.  
Storage falls back to localStorage when the API is unreachable.  
```

A body with long sentences - each sentence starts a new line, and a  
sentence too long for ~82 cols hard-breaks at a natural point instead of  
running as one giant line. The blank line marks the second idea (the fix):

```
🐛 fix(peering): derive NACL rule numbers from pair hash

Rule numbers were computed from each tray's alphabetical position  
in the full trays.yaml list.  
Since that registry is fetched dynamically, adding or removing any  
earlier-sorting tray shifted later trays' indices and renumbered  
their NACL rules.  
rule_number is the AWS identity of a NACL rule and cannot change in  
place, so every shift destroyed and recreated rules fleet-wide.  

Derive the base from a hash of the peering pair's slugs instead, so  
the slot depends only on the two trays in the pair.  
Adds an override map for the rare hash collision.  

Task: https://redbull-gms.atlassian.net/browse/MITCESQ-2558
```

A docs typo:

```
✏️ docs: correct install command in README
```

A dependency bump:

```
⬆️ build(deps): upgrade vite to 5.4.2
```

A revert:

```
⏪️ revert: feat(cart): support saving items for later

Refs: #771
```

## Process when asked to write a commit message

1. Inspect what changed (staged diff, file list, or the user's description).  
2. **Always ask for references before drafting - no exceptions, every time.**  
  Even if this exact conversation asked before, ask again for a new commit;  
  never reuse a stale answer. Ask with the AskUserQuestion tool, **both  
  questions in a single call**, so the user can type real values, not just  
  signal intent:  

  - **Question 1 - JIRA ticket.** Header `JIRA`, e.g. "JIRA ticket for this  
    work? Type the key or URL." Options: `No ticket` (opt-out). The user types  
    the actual key (e.g. `MITCESQ-2558`) or full URL into the free-text  
    "Other" field - that free-text path is the point of this question.  
  - **Question 2 - Other references.** Header `References`, e.g. "Other links  
    or references to include? Paste links with a short note, one per line."  
    Options: `No other references` (opt-out). This question exists purely for  
    the free-text field - PR links, docs, Slack threads, `Refs: #123`,  
    reviewer names, anything the user wants to cite.  

  The **only** valid reason to skip asking is that the user already gave  
  references unprompted in the same message that asked for the commit  
  message (e.g. "commit this, ticket is MITCESQ-2558, no other refs"). Do not  
  skip because a similar-looking commit was drafted earlier, and do not skip  
  by assuming "no ticket" - always let the user say so.  

  **Never emit a placeholder.** The bug to avoid: the user picks "add a  
  ticket" but you never get the value, then you write `<KEY>` or a blank URL.  
  If the user indicated they want a ticket or references but you do not have  
  the concrete value in hand, ask again (plain follow-up) until you have the  
  real string. A commit must never contain `<KEY>`, `<url>`, or any  
  placeholder - only real values the user actually gave.  

  **JIRA ticket footer.** Take the ticket from Question 1 (the first one the  
  user gives) and add it as the footer at the very bottom, in this exact form:  

  ```
  Task: https://redbull-gms.atlassian.net/browse/MITCESQ-2558
  ```

  If the user typed a bare key like `MITCESQ-2558`, expand it into the full  
  `https://redbull-gms.atlassian.net/browse/` + key URL yourself. If they  
  pasted a full JIRA URL, use it as-is. Only the first ticket becomes the  
  `Task:` footer.  

  **Other references footer(s).** Turn each link/note from Question 2 into its  
  own footer (e.g. `See: <url>`, `Doc: <url>`, or `Ref: <url> - <note>`), one  
  per line, placed above the `Task:` line.  
3. Decide the single most accurate `type`.  
4. Pick the gitmoji that matches the intent, not just the type.  
5. Add a scope only if it sharpens the message.  
6. Write an imperative, lowercase description. Aim for ~50 characters but keep  
  a whole idea intact if it lands within ±10 (up to ~60); don't pad or truncate.  
7. Add a body only when the *why* isn't obvious from the description.  
  Start every sentence on its own line, ending each line with two trailing  
  spaces (always - including a paragraph's last line). Wrap at ~72 cols;  
  overrun by at most ~10 (ceiling ~82), then hard-break long sentences  
  rather than letting them run as one giant line. Put a blank line between  
  sentences only when they cover a different idea, change, or explanation -  
  that starts a new paragraph.  
8. Add footers for the references gathered in step 2, plus reviewers or  
  breaking changes.  
9. If the change really does two unrelated things, suggest splitting it  
  into two commits rather than cramming both into one message.  
10. Never add a co-author, "Generated with" line, or any AI attribution.  
11. Write the message to `commit_msg.md` at the repo root (see "Where the  
  message goes" above), show it inline too, and stop there - do not run  
  `git commit`, stage files, or create/switch branches (see Scope above).