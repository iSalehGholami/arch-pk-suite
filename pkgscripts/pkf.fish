function pkf --description 'Smart find: shows install status and source'
    if test -z "$argv[1]"
        echo "Usage: pkf <package-name>"
        return 1
    end

    set pkg $argv[1]

    if pacman -Qi "$pkg" &>/dev/null
        pacman -Qi "$pkg" | grep -E "^(Name|Version|Install Reason)"
        if pacman -Si "$pkg" &>/dev/null
            echo "Source: Official Repo"
        else
            echo "Source: AUR / Foreign"
        end
    else
        # Not installed locally — search remote repos + AUR
        echo "'$pkg' not installed locally. Searching remote..."
        if pacman -Ss "$pkg" 2>/dev/null | head -20
            echo "---"
        end
        if command -q yay
            echo "AUR results:"
            yay -Ss "$pkg" 2>/dev/null | head -20
        end
    end
end