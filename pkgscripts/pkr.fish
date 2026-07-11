function pkr --description 'Smart remove: auto-detects pacman/yay/AUR variant'
    if test -z "$argv[1]"
        echo "Usage: pkr <package-name>"
        return 1
    end

    set search_term $argv[1]
    set found_pkgs (pacman -Qq | grep -i "^$search_term")

    if test -z "$found_pkgs"
        echo "✗ No installed package matching '$search_term'"
        return 1
    end

    echo "Found: $found_pkgs"
    read -P "Remove? [Y/n] " confirm

    if test "$confirm" = "" -o "$confirm" = "y" -o "$confirm" = "Y"
        sudo pacman -Rns $found_pkgs
    else
        echo "Cancelled."
    end
end