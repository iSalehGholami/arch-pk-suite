#!/usr/bin/env fish
# ╔══════════════════════════════════════════════════════════╗
# ║     Arch Smart Package Manager Suite — Standalone       ║
# ║              Author: @iSalehGholami                     ║
# ╚══════════════════════════════════════════════════════════╝

set -l GREEN "\033[1;32m"; set -l CYAN "\033[1;36m"
set -l YELLOW "\033[1;33m"; set -l RED "\033[1;31m"; set -l RESET "\033[0m"

if test -z "$HOME"; echo -e "$RED✗ \$HOME is not set.$RESET"; exit 1; end
set -g FUNC_DIR "$HOME/.config/fish/functions"

function _print_header
    echo -e "\n$CYAN╔══════════════════════════════════════════════════════════╗$RESET"
    echo -e "$CYAN║$RESET   📦  Arch PK Suite — Standalone Installer             $CYAN║$RESET"
    echo -e "$CYAN║$RESET   👤  Author: @iSalehGholami                           $CYAN║$RESET"
    echo -e "$CYAN╚══════════════════════════════════════════════════════════╝$RESET\n"
end

function _write_func
    set -l name $argv[1]
    set -l desc $argv[2]
    set -l body $argv[3]
    set -l target_path "$FUNC_DIR/$name.fish"

    printf '%s\n' "# Author: @iSalehGholami" "function $name --description '$desc'" "$body" "end" \
        | tee "$target_path" > /dev/null

    if test $status -ne 0
        echo -e "  $RED✗ Failed: $target_path$RESET"
        return 1
    end
    echo -e "  $GREEN✓$RESET $YELLOW$name$RESET → $desc"
end

_print_header
mkdir -p $FUNC_DIR
echo -e "$CYAN▸ Installing to $FUNC_DIR$RESET\n"

set -l REMOVE_BODY '    if test -z "$argv[1]"
        echo "Usage: $argv[0] <pkg>"
        return 1
    end
    set found (pacman -Qq | grep -i "^$argv[1]")
    if test -z "$found"
        echo "✗ Not found: '"'"'$argv[1]'"'"'"
        return 1
    end
    echo "Found: $found"
    read -P "Remove? [Y/n] " c
    if test "$c" = "" -o "$c" = "y" -o "$c" = "Y"
        sudo pacman -Rns $found
    else
        echo "Cancelled."
    end'

set -l INSTALL_BODY '    if test -z "$argv[1]"
        echo "Usage: $argv[0] <pkg>"
        return 1
    end
    if pacman -Qq "$argv[1]" &>/dev/null
        echo "✓ Already installed"
        return 0
    end
    if pacman -Si "$argv[1]" &>/dev/null
        sudo pacman -S --needed $argv[1]
    else if command -q yay
        yay -S --needed $argv[1]
    else
        echo "✗ Not found & no yay"
        return 1
    end'

set -l INFO_BODY '    if test -z "$argv[1]"
        echo "Usage: $argv[0] <pkg>"
        return 1
    end
    if pacman -Qi "$argv[1]" &>/dev/null
        pacman -Qi "$argv[1]" | grep -E "^(Name|Version|Install Reason)"
        if pacman -Si "$argv[1]" &>/dev/null
            echo "Source: Repo"
        else
            echo "Source: AUR"
        end
    else
        echo "Not installed. Searching..."
        pacman -Ss "$argv[1]" 2>/dev/null | head -10
        if command -q yay
            echo "--- AUR ---"
            yay -Ss "$argv[1]" 2>/dev/null | head -10
        end
    end'

set -l LIST_BODY '    if test -n "$argv[1]"
        set matched (pacman -Qq | grep -i "$argv[1]")
        if test -z "$matched"
            echo "✗ No match for '"'"'$argv[1]'"'"'"
            return 1
        end
        for p in $matched
            set s repo
            pacman -Si "$p" &>/dev/null; or set s aur
            set ver (pacman -Q "$p" | cut -d" " -f2)
            printf "  %-30s %-15s [%s]\n" "$p" "$ver" "$s"
        end
    else
        set all_pkgs (pacman -Qq)
        set total (count $all_pkgs)
        echo "Installed packages ($total):"
        echo ""
        for p in $all_pkgs
            set s repo
            pacman -Si "$p" &>/dev/null; or set s aur
            set ver (pacman -Q "$p" | cut -d" " -f2)
            printf "  %-30s %-15s [%s]\n" "$p" "$ver" "$s"
        end
        echo ""
        echo "Total: $total packages"
    end'

_write_func "pkr"       "Smart remove"             $REMOVE_BODY
_write_func "pkgremove" "Smart remove (longform)"   $REMOVE_BODY
_write_func "pki"      "Smart install"              $INSTALL_BODY
_write_func "pkginst"  "Smart install (longform)"   $INSTALL_BODY
_write_func "pkf"      "Smart find/info"            $INFO_BODY
_write_func "pkginfo"  "Smart find/info (longform)" $INFO_BODY
_write_func "pkl"      "Smart list with tags"       $LIST_BODY
_write_func "pkgls"    "Smart list (longform)"      $LIST_BODY

echo -e "\n$CYAN▸ Done!$RESET  Made with ♥ by $CYAN@iSalehGholami$RESET\n"