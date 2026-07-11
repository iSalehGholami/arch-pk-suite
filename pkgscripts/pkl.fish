# Smart list with repo/aur tags
if test -n "$argv[1]"
    set matched (pacman -Qq | grep -i "$argv[1]")
    if test -z "$matched"
        echo "✗ No installed packages matching '$argv[1]'"
        return 1
    end
    for p in $matched
        set s repo
        pacman -Si "$p" &>/dev/null; or set s aur
        set ver (pacman -Q "$p" | cut -d' ' -f2)
        printf '  %-30s %-15s [%s]\n' "$p" "$ver" "$s"
    end
else
    set all_pkgs (pacman -Qq)
    set total (count $all_pkgs)
    echo "Installed packages ($total):"
    echo ""
    for p in $all_pkgs
        set s repo
        pacman -Si "$p" &>/dev/null; or set s aur
        set ver (pacman -Q "$p" | cut -d' ' -f2)
        printf '  %-30s %-15s [%s]\n' "$p" "$ver" "$s"
    end
    echo ""
    echo "Total: $total packages"
end