# This file is actually for Bash on Ubuntu on Windows!

clip() {
	local sleep_argv0="password store sleep on display $DISPLAY"
	pkill -f "^$sleep_argv0" 2>/dev/null && sleep 0.5
	local before="$(read_from_clipboard | base64)"

    write_to_clipboard "$(echo -n "$1")"
	(
		( exec -a "$sleep_argv0" sleep "$CLIP_TIME" )
		local now="$(read_from_clipboard | base64)"

		[[ $now != $(echo "$1" | base64) ]] && before="$now"
        write_to_clipboard "$(echo "$before" | base64 -d)"
	) 2>/dev/null & disown
	echo "Copied $2 to clipboard. Will clear in $CLIP_TIME seconds."
}

read_from_clipboard() {
    local text="$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetText()")"
    # Remove trailing carriage return:
    echo "${text:0:-1}"
}

write_to_clipboard() {
    # Escape for PowerShell:
    local text="${1//\'/\'\'}"
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::SetText('$text')"
}
