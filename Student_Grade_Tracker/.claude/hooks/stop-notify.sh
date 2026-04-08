#!/usr/bin/env bash
# Stop hook — sends a Windows desktop notification when Claude finishes a task

TITLE="Claude Code"
MESSAGE="Task complete — Student Grade Tracker"

# Try PowerShell toast notification (Windows 10/11)
if command -v powershell.exe &>/dev/null; then
  powershell.exe -NoProfile -NonInteractive -Command "
    Add-Type -AssemblyName System.Windows.Forms
    \$notify = New-Object System.Windows.Forms.NotifyIcon
    \$notify.Icon = [System.Drawing.SystemIcons]::Information
    \$notify.Visible = \$true
    \$notify.ShowBalloonTip(4000, '$TITLE', '$MESSAGE', [System.Windows.Forms.ToolTipIcon]::Info)
    Start-Sleep -Milliseconds 4500
    \$notify.Dispose()
  " 2>/dev/null && exit 0
fi

# Fallback: BurntToast module if available
if powershell.exe -NoProfile -Command "Get-Module -ListAvailable BurntToast" &>/dev/null 2>&1; then
  powershell.exe -NoProfile -NonInteractive -Command \
    "Import-Module BurntToast; New-BurntToastNotification -Text '$TITLE','$MESSAGE'" 2>/dev/null
fi

exit 0
