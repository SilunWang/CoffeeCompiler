#!/bin/bash
watchmedo shell-command \
    --patterns="*.coffee" \
    --recursive \
    --command='node entry.js test.coffee > test.js' \
    .
