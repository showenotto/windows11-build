# Only launch if we are in PowerShell 7+ and NOT already in tmux
if ($PSVersionTable.PSVersion.Major -ge 7 -and -not $env:TMUX) {
    # Generate a unique session name based on the current time/ID
    $sessionName = "session_$(Get-Random)"
    tmux new-session -s $sessionName
}