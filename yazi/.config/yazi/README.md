# Requirements

1. git: for git.yazi plugin
2. starship: for starship.yazi plugin

# Extra Configured Usage

1. Change dir within yazi
    - Paste the function below to `.bashrc/.zshrc` and use `y` to launch yazi.
```
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
```

2. file compress inside yazi
    - Implemented via compress.yazi plugin
    - Select files inside yazi, then press `ca`
