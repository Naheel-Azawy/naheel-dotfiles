#!/bin/sh

set -C -f -u
IFS=$'\n'

# ANSI color codes are supported.
# STDIN is disabled, so interactive scripts won't work properly

# This script is considered a configuration file and must be updated manually.

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | Display stdout as preview
# 1    | no preview | Display no preview at all
# 2    | plain text | Display the plain content of the file

# Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
IMAGE_CACHE_PATH="$HOME/.cache/lfimg/$(basename $FILE_PATH).jpg"  # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="False"  # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER=$(echo ${FILE_EXTENSION} | tr '[:upper:]' '[:lower:]')

# Settings
HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_TABWIDTH=4
HIGHLIGHT_STYLE='pablo'
PYGMENTIZE_STYLE='autumn'

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        # Archive
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            atool --list -- "${FILE_PATH}"
            bsdtar --list --file "${FILE_PATH}"
            exit 1;;
        rar)
            # Avoid password prompt by providing empty password
            unrar lt -p- -- "${FILE_PATH}"
            exit 1;;
        7z)
            # Avoid password prompt by providing empty password
            7z l -p -- "${FILE_PATH}"
            exit 1;;

        # PDF
        pdf)
            # Preview as text conversion
            pdftotext -layout -l 10 -nopgbrk -q -- "${FILE_PATH}" -
            mutool draw -F txt -i -- "${FILE_PATH}" 1-10
            exiftool "${FILE_PATH}"
            exit 1;;

        # BitTorrent
        torrent)
            transmission-show -- "${FILE_PATH}"
            exit 1;;

        # OpenDocument
        odt|ods|odp|sxw)
            # Preview as text conversion
            odt2txt "${FILE_PATH}"
            exit 1;;

        # HTML
        htm|html|xhtml)
            # Preview as text conversion
            w3m -dump "${FILE_PATH}"
            lynx -dump -- "${FILE_PATH}"
            elinks -dump "${FILE_PATH}"
            ;; # Continue with next handler on failure

        # JSON
        json)
            cat "${FILE_PATH}" | jq -C . && exit 5
            exit 2;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
        # Text
        text/* | */xml)
            # Syntax highlight
            if [ "$( stat --printf='%s' -- "${FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]; then
                exit 2
            fi
            if [ "$( tput colors )" -ge 256 ]; then
                local pygmentize_format='terminal256'
                local highlight_format='xterm256'
            else
                local pygmentize_format='terminal'
                local highlight_format='ansi'
            fi
            highlight --replace-tabs="${HIGHLIGHT_TABWIDTH}" --out-format="${highlight_format}" \
                --style="${HIGHLIGHT_STYLE}" --force -- "${FILE_PATH}"
            # pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" -- "${FILE_PATH}"
            exit 2;;

        # Image
        image/*)
            # Preview as text conversion
            # img2txt --gamma=0.6 -- "${FILE_PATH}" && exit 1
            exiftool "${FILE_PATH}"
            exit 1;;

        # Video and audio
        video/* | audio/*|application/octet-stream)
            mediainfo "${FILE_PATH}"
            exiftool "${FILE_PATH}"
            exit 1;;
    esac
}

handle_image() {
    local mimetype="${1}"
    case "${mimetype}" in
        # SVG
        # image/svg+xml)
        #     convert "${FILE_PATH}" "${IMAGE_CACHE_PATH}" && exit 6
        #     exit 1;;

        # Image
        image/*)
            local orientation
            orientation="$( identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}" )"
            # If orientation data is present and the image actually
            # needs rotating ("1" means no rotation)...
            if [[ -n "$orientation" && "$orientation" != 1 ]]; then
                # ...auto-rotate the image according to the EXIF data.
                convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && return
            else
                IMAGE_CACHE_PATH="${FILE_PATH}" && return
            fi

            # `w3mimgdisplay` will be called for all images (unless overriden as above),
            # but might fail for unsupported types.
            exit 1;;

        # Video
        video/*)
            # Thumbnail
            ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && return
            exit 1;;
        # PDF
        application/pdf)
            pdftoppm -f 1 -l 1 \
                     -scale-to-x 1920 \
                     -scale-to-y -1 \
                     -singlefile \
                     -jpeg -tiffcompression jpeg \
                     -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" \
                && imgdarken "${IMAGE_CACHE_PATH}" \
                && return || exit 1;;
        # Office files
        application/*office*|application/ms*|application/vnd.ms-*)
            CACHE_DIR="${IMAGE_CACHE_PATH%/*}"
            TMP_FILE_PATH="${FILE_PATH##*/}"
            TMP_FILE_PATH="${CACHE_DIR}/${TMP_FILE_PATH%.*}.png"
            libreoffice \
                       --headless \
                       --convert-to png "${FILE_PATH}" \
                       --outdir "$CACHE_DIR" \
                && convert "$TMP_FILE_PATH" "${IMAGE_CACHE_PATH}" \
                && rm -f "$TMP_FILE_PATH" \
                && imgdarken "${IMAGE_CACHE_PATH}" \
                && return || exit 1;;
    esac
}

preview_img() {
    echo "
# lock file
L=/tmp/lfimglock

# remove lock
rm -f \$L

source \"`ueberzug library`\"

# considering the ratio 1:2:3 then the preview starts in the middle
COLS=\$((\$(tput cols) / 2))

# remove the top and bottom lines as they are used by lf
LINS=\$((\$(tput lines) - 2))

{
    ImageLayer::add [identifier]=\"img0\" \
                    [path]=\"$1\" \
                    [x]=\"\$COLS\" [y]=\"1\" \
                    [max_width]=\"\$COLS\" [max_height]=\"\$LINS\"
    sleep 0.1 # make sure others noticed
    touch \$L
    while [[ -f \$L ]]; do # wait till someone remove it
        sleep 0.1
    done
    ImageLayer::remove [identifier]=\"img0\"
} | ImageLayer
" | bash
    exit 1
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}"
    exit 1
}

{
    MIMETYPE="$( file --dereference --brief --mime-type -- "${FILE_PATH}" )"
    [[ "${PV_IMAGE_ENABLED}" == 'True' ]] && \
        handle_image "${MIMETYPE}" && \
        preview_img "${IMAGE_CACHE_PATH}"
    handle_extension
    handle_mime "${MIMETYPE}"
    handle_fallback
} | fribidi

exit 1
