find ./old -type f | while read -r s; do
    echo "$s"
    grep -l -r --color=always "$(basename "$s")"
    echo
done
