#!/usr/bin/env python3
"""Custom Claude Code status line.

Reads the status-line JSON that Claude Code sends on stdin and prints one
formatted line:

    dir | Model (effort) | [bar] pct% (used/total tok) | $cost duration

Uses python3 (no dependency on jq) so it works on any machine that ships
Python 3, which Claude Code itself requires.
"""

import json
import os
import sys


def fmt_k(n):
    k = n / 1000
    return f"{k:.0f}k" if k >= 100 else f"{k:.1f}k"


def main():
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        data = {}

    workspace = data.get("workspace") or {}
    cwd = workspace.get("current_dir") or data.get("cwd") or ""
    home = os.path.expanduser("~")
    if cwd.startswith(home):
        cwd = "~" + cwd[len(home):]

    model = data.get("model") or {}
    model_name = model.get("display_name") or "Claude"
    if model_name.startswith("Claude "):
        model_name = model_name[len("Claude "):]

    effort = (data.get("effort") or {}).get("level")

    cost_info = data.get("cost") or {}
    cost = cost_info.get("total_cost_usd") or 0
    duration_ms = cost_info.get("total_duration_ms") or 0

    ctx = data.get("context_window") or {}
    used_tokens = ctx.get("total_input_tokens") or 0
    window_size = ctx.get("context_window_size") or 200000
    used_pct = ctx.get("used_percentage")
    if used_pct is None:
        used_pct = (used_tokens / window_size * 100) if window_size else 0
    used_pct = round(used_pct)

    used_fmt = fmt_k(used_tokens)
    total_fmt = fmt_k(window_size)

    bar_width = 20
    filled = max(0, min(bar_width, round(used_pct / 100 * bar_width)))
    empty = bar_width - filled

    # 256-color ANSI codes, tuned for a dark terminal.
    RESET = "\033[0m"
    GRAY = "\033[38;5;244m"
    CYAN = "\033[38;5;117m"
    MAGENTA = "\033[1;38;5;213m"
    YELLOW = "\033[38;5;221m"
    BAR_FILL = "\033[38;5;142m"
    BAR_EMPTY = "\033[38;5;238m"
    PURPLE = "\033[38;5;141m"

    sep = f"{GRAY} | {RESET}"

    model_part = f"{model_name} ({effort})" if effort else model_name
    bar = f"{BAR_FILL}{'#' * filled}{BAR_EMPTY}{'-' * empty}{RESET}"

    total_seconds = duration_ms / 1000
    minutes = int(total_seconds // 60)
    seconds = int(total_seconds % 60)
    dur_fmt = f"{minutes}m{seconds}s" if minutes > 0 else f"{seconds}s"
    cost_fmt = f"${cost:.2f}"

    line = (
        f"\U0001F4C1 {CYAN}{cwd}{RESET}{sep}"
        f"{MAGENTA}{model_part}{RESET}{sep}"
        f"[{bar}] {YELLOW}{used_pct}% ({used_fmt}/{total_fmt} tok){RESET}{sep}"
        f"{PURPLE}{cost_fmt} {dur_fmt}{RESET}"
    )
    print(line)


if __name__ == "__main__":
    main()
