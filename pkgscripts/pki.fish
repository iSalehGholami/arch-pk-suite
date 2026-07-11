function pki --description 'Smart install: pacman first, yay fallback'
    if test -z "$argv[1]"
        echo "Usage: pki <package-name>"
        return 1
    end

    set pkg $argv[1]

    if pacman -Qq "$pkg" &>/dev/null
        echo "✓ '$pkg' already installed."
        return 0
    end

    if pacman -Si "$pkg" &>/dev/null
        echo "→ Official repo. Using pacman..."
        sudo pacman -S --needed $pkg
    else if command -q yay
        echo "→ AUR. Using yay..."
        yay -S --needed $pkg
    else
        echo "✗ Not found in repos and yay not installed."
        return 1
    end
end