#!/bin/bash
watchmedo shell-command \
    --patterns="*.coffee" \
    --recursive \
    --command='node parser.js test.coffee > test.js' \
    .
