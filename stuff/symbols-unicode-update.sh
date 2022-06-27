#!/bin/sh

curl 'https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt' |
    while IFS=';' read -r code comment _; do
        u=$(env printf '%b' "\\u$code" 2>/dev/null)
        env printf '| %s | \\u%s | %s |\n' "$u" "$code" "$comment"
    done >./symbols-unicode.org
