#!/bin/bash

script_path="$(realpath "$0")"
for item in *; do 
    if [[ "$(realpath "$item")" != "$script_path" ]]; then
        rm -f "$item"
    fi
done

echo "Текущая директория очищена."
