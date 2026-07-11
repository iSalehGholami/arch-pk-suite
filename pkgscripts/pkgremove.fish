# ~/.config/fish/functions/pkgremove.fish

function pkgremove --description 'Smart remove: finds installed variant (pacman/yay/AUR) and purges'
    if test -z "$argv[1]"
        echo "Usage: pkgremove <package-name>"
        return 1
    end

    set search_term $argv[1]
    
    # Find all installed packages matching the term (covers postman, postman-bin, etc.)
    # -Qq = query local DB, quiet output (names only)
    set found_pkgs (pacman -Qq | grep -i "^$search_term")

    if test -z "$found_pkgs"
        echo "✗ No installed package matching '$search_term' found."
        return 1
    end

    echo "Found installed package(s): $found_pkgs"
    read -P "Remove these? [Y/n] " confirm
    
    if test "$confirm" = "" -o "$confirm" = "y" -o "$confirm" = "Y"
        # -Rns = Remove + NoSave config + Recursive deps
        sudo pacman -Rns $found_pkgs
    else
        echo "Cancelled."
    end
end