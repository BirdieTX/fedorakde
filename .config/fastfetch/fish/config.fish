if status is-interactive
	# Commands to run in interactive sessions can go here

	# Remove fish greeting
	set -U fish_greeting

		# User defined functions
		alias fedora='$HOME/.scripts/upgrade.sh'
		alias ff='fastfetch'
		alias fft='fastfetch -c $HOME/.config/fastfetch/term.jsonc'
		alias neofetch='fastfetch -c neofetch'
		alias nf='fastfetch -c neofetch'
		alias patch='$HOME/.scripts/patch.sh'

	# Run fastfetch configuration on shell startup (expect tty)
	fastfetch -c ~/.config/fastfetch/term.jsonc
end
