#!/bin/bash

function nodeCleanUp() {
    rm -fr node_modules
    yarn install --production=true
}

cd /home/dodock/dodock-bench/apps/frappe
yarn
yarn run production

if [[ "$GIT_BRANCH" =~ ^(master|develop)$ ]]; then
    nodeCleanUp
else
    nodeCleanUp
    yarn add node-sass
fi
