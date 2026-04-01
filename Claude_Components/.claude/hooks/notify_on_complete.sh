#!/bin/bash
# Stop Hook - Shows a Windows desktop notification when Claude finishes a response
#
# Fires every time Claude completes a response (Stop event).
# Uses PowerShell to trigger a native Windows toast notification.
#
# Exit codes:
#   0 = always allow

INPUT=$(cat)

# Extract stop reason if available
STOP_REASON=$(echo "$INPUT" | grep -o '"stop_reason":"[^"]*"' | sed 's/"stop_reason":"//;s/"//')

TITLE="Claude Code"
MESSAGE="Task completed!"

if [[ "$STOP_REASON" == "error" ]]; then
    MESSAGE="Task finished with an error."
fi

# Trigger Windows toast notification via PowerShell
/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -NonInteractive -Command "
Add-Type -AssemblyName System.Windows.Forms
\$notify = New-Object System.Windows.Forms.NotifyIcon
\$notify.Icon = [System.Drawing.SystemIcons]::Information
\$notify.BalloonTipIcon = 'Info'
\$notify.BalloonTipTitle = '$TITLE'
\$notify.BalloonTipText = '$MESSAGE'
\$notify.Visible = \$true
\$notify.ShowBalloonTip(5000)
Start-Sleep -Seconds 5
\$notify.Dispose()
" &>/dev/null &

exit 0
