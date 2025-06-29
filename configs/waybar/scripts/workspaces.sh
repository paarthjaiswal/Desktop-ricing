#!/bin/bash

active=$(hyprctl activeworkspace -j | jq -r '.name')
workspaces=$(hyprctl workspaces -j | jq -r '.[] | .name')

json_output="{\"text\":\""

for name in $workspaces; do
    if [[ "$name" == "$active" ]]; then
        json_output+="<$name> "
    else
        json_output+="{${name}} "
    fi
done

json_output="${json_output% }\"}"
echo "$json_output"
