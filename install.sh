#!/bin/sh

command -v curl >/dev/null || {
    command -v apt >/dev/null && sudo apt install --yes curl
}

if [ "$1" = '--docker' ]; then
    IMG='arch-naheel'
    if docker images | cut -d ' ' -f 1 | grep "$IMG" -q; then
        echo "Image '$IMG' already exist"
        echo "remove with 'docker rmi $IMG'"
    else
        echo "Building image ($IMG)..."
        docker build -t "$IMG" .
    fi
    echo 'Running docker image...'
    docker run -it --rm "$IMG"

elif [ -f ./scripts/nd ]; then
    exec ./scripts/nd install dots "$@"

else
    echo 'Downloading dotfiles...'
    cd && rm -rf naheel-dotfiles-master &&
        curl -sL https://github.com/Naheel-Azawy/naheel-dotfiles/archive/master.tar.gz |
            tar xz &&
        mv naheel-dotfiles-master .dotfiles &&
        cd .dotfiles &&
        ./install.sh "$@"

fi
