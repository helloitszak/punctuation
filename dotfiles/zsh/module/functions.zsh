function {
    local pfunction_glob='^([_.]*|prompt_*_setup|README*|*~)(-.N:t)'
    local function_root=${PUNC[ZSH]}/function
    local paths=("$function_root/all")

    if [[ "$OSTYPE" == darwin* ]]; then
        paths+=("$function_root/osx")
    fi

    fpath=(
        $paths
        $fpath
    )

    local ppath
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    for ppath in "$paths[@]"; do
        for pfunction in ${ppath}/$~pfunction_glob; do
          autoload -Uz "$pfunction"
        done
    done
}
