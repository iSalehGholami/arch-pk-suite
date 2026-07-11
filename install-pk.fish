#!/usr/bin/env fish
# ╔══════════════════════════════════════════════════════════╗
# ║   Arch Smart PK Suite — Relative Directory Installer    ║
# ║              Author: @iSalehGholami                     ║
# ╚══════════════════════════════════════════════════════════╝

set -l GREEN "\033[1;32m"; set -l CYAN "\033[1;36m"
set -l YELLOW "\033[1;33m"; set -l RED "\033[1;31m"; set -l RESET "\033[0m"

if test -z "$HOME"; echo -e "$RED✗ \$HOME is not set.$RESET"; exit 1; end
set -g FUNC_DIR "$HOME/.config/fish/functions"

set -l SCRIPT_DIR (dirname (status filename))
set -l SRC_DIR "$SCRIPT_DIR/pkgscripts"

function _print_header
    echo -e "\n$CYAN╔══════════════════════════════════════════════════════════╗$RESET"
    echo -e "$CYAN║$RESET   📦  Arch PK Suite — Directory Installer              $CYAN║$RESET"
    echo -e "$CYAN║$RESET   👤  Author: @iSalehGholami                           $CYAN║$RESET"
    echo -e "$CYAN╚══════════════════════════════════════════════════════════╝$RESET\n"
end

function _install_from_file
    set -l src_file $argv[1]
    set -l name (path basename $src_file .fish)
    set -l target_path "$FUNC_DIR/$name.fish"

    if not test -f "$src_file"
        echo -e "  $RED✗ Missing: $src_file$RESET"
        return 1
    end

    set -l desc (head -1 "$src_file" | string replace -r '^#\s*' '')
    if test -z "$desc"; set desc "Arch PK Suite function"; end

    set -l body (cat "$src_file")

    printf '%s\n' "# Author: @iSalehGholami" "function $name --description '$desc'" "$body" "end" \
        | tee "$target_path" > /dev/null

    if test $status -ne 0
        echo -e "  $RED✗ Failed: $target_path$RESET"
        return 1
    end
    echo -e "  $GREEN✓$RESET $YELLOW$name$RESET → $desc"
end

_print_header

if not test -d "$SRC_DIR"
    echo -e "$RED✗ Source directory not found: $SRC_DIR$RESET"
    echo -e "  Expected pkgscripts/ next to this installer.\n"
    exit 1
end

mkdir -p $FUNC_DIR
echo -e "$CYAN▸ Source:  $SRC_DIR$RESET"
echo -e "$CYAN▸ Target:  $FUNC_DIR$RESET\n"

for src_file in $SRC_DIR/*.fish
    _install_from_file "$src_file"
end

echo -e "\n$CYAN▸ Done!$RESET  Made with ♥ by $CYAN@iSalehGholami$RESET\n"