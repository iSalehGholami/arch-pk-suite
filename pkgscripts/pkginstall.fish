# ~/.config/fish/functions/pkginst.fish

function pkginst --description 'Smart install: uses pacman if available, falls back to yay'
    if test -z "$argv[1]"
        echo "Usage: pkginst <package-name>"
        return 1
    end

    set pkg $argv[1]

    # Check if already installed
    if pacman -Qq "$pkg" &>/dev/null
        echo "✓ '$pkg' is already installed."
        return 0
    end

    # Check official repos first (fast, no network needed if sync'd)
    if pacman -Si "$pkg" &>/dev/null
        echo "→ Found in official repos. Installing via pacman..."
        sudo pacman -S --needed $pkg
    else if command -q yay
        echo "→ Not in official repos. Searching AUR via yay..."
        yay -S --needed $pkg
    else
        echo "✗ Package not found in repos and yay is not installed."
        return 1
    end
end