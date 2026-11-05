import json
import select
import subprocess
import sys
import time

FIVE_HOUR_REMAINING_PERCENT = 0
WEEKLY_REMAINING_PERCENT = 0


def check():
    proc = subprocess.Popen(
        [sys.argv[1], "app-server"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        bufsize=0,
    )
    try:
        messages = [
            {
                "id": 1,
                "method": "initialize",
                "params": {"clientInfo": {"name": "limit_guard", "version": "1"}},
            },
            {"method": "initialized", "params": {}},
            {"id": 2, "method": "account/rateLimits/read"},
        ]
        for message in messages:
            proc.stdin.write((json.dumps(message) + "\n").encode())
        proc.stdin.flush()
        deadline = time.monotonic() + 10
        while time.monotonic() < deadline:
            ready, _, _ = select.select(
                [proc.stdout], [], [], max(0, deadline - time.monotonic())
            )
            if not ready:
                break
            line = proc.stdout.readline()
            if not line:
                break
            response = json.loads(line)
            if response.get("id") != 2:
                continue
            limits = response["result"]["rateLimits"]
            windows = {
                w["windowDurationMins"]: w
                for w in (limits.get("primary"), limits.get("secondary"))
                if w
            }
            for duration, remaining in (
                (300, FIVE_HOUR_REMAINING_PERCENT),
                (10080, WEEKLY_REMAINING_PERCENT),
            ):
                window = windows[duration]
                if window["usedPercent"] > 100 - remaining:
                    return f"Codex usage limit: {duration} minute window used {window['usedPercent']}%; resets at {window.get('resetsAt')}."
            return None
        raise RuntimeError("rate limits unavailable")
    finally:
        proc.kill()
        proc.wait()


def main():
    event = json.load(sys.stdin).get("hook_event_name")
    try:
        reason = check()
    except Exception:
        reason = "Codex usage limits could not be verified. Stop work immediately."
    if reason:
        reason += " Stop work immediately; do not call more tools."
        if event == "PreToolUse":
            print(
                json.dumps(
                    {
                        "hookSpecificOutput": {
                            "hookEventName": "PreToolUse",
                            "permissionDecision": "deny",
                            "permissionDecisionReason": reason,
                            "additionalContext": reason,
                        }
                    }
                )
            )
        else:
            print(
                json.dumps(
                    {"continue": False, "stopReason": reason, "systemMessage": reason}
                )
            )


if __name__ == "__main__":
    main()
