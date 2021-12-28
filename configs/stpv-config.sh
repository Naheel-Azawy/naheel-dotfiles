PV_IMAGE_ENABLED=1 # show image previews when possible
PV_TYPE=img        # (img or text) where text shows image previews in the terminal
PREFER_TEXT=       # prefer text over images when displaying documents
DARK_DOCS=1        # invert documents preview color in image previews
SAFE=1             # kill itself if needed (check main for details)

#       function    type dep    dep-image
add_top handle_cows cows cowsay -
handle_cows() {
    [ "$file_extension_lower" = moo ] ||
        return "$RET_NO_MATCH"

    cowsay < "$file_path"
}
