#!/bin/bash
watchmedo shell-command \
    --patterns="*.coffee" \
    --recursive \
    --command='node Indent.js binary_search.coffee > indent_binary_search.coffee' \
    .
