#!/bin/bash

tmp_cleanup(){
    rm "$tmpfile"
}

trap tmp_cleanup EXIT INT
menu=dmenu
menu_flags=(-nb "#1a1b26" -nf "#f7768e" -sb "#24283b" -sf "#7aa2f7")
menu_cmd="$menu ${menu_flags[@]}"
tmpfile=$(mktemp /tmp/tmp_csvmenu_XXXXX.csv)
if [ "$#" -ne 1 ]; then
    echo "too many or too little filenames given"
    exit 1
fi
sed '/^\s*#/d' "$1" > "$tmpfile"
options=$(awk -F',' '{print $1}' "$tmpfile")
selected_option=$($menu_cmd <<< "$options")
cmd=$(awk -F',' -v val="$selected_option" '$1 == val {print $2}' "$tmpfile")
if [ -z "$cmd" ]; then
    exit 1
fi
$cmd &
