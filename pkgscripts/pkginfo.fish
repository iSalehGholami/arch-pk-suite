# ~/.config/fish/functions/pkginfo.fish

function pkginfo --description 'Show package origin and details regardless of install method'
    if test -z "$argv[1]"
        echo "Usage: pkginfo <package-name>"
        return 1
    end

    set pkg $argv[1]

    if pacman -Qi "$pkg" &>/dev/null
        echo "=== LOCAL INSTALL INFO ==="
        pacman -Qi "$pkg" | grep -E "^(Name|Version|Install Reason|Description)"
        
        # Determine source
        if pacman -Si "$pkg" &>/dev/null
            echo "Source: Official Repository"
        else
            echo "Source: AUR / Foreign Package"
        end
    else
        echo "Package '$pkg' is not installed locally."
    end
end