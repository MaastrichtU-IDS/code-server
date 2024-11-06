#!/bin/sh

if [ -n "$GIT_URL" ]; then
    git clone $GIT_URL /home/coder/project
fi

sudo chown -R 1000:1000 /home/coder/project
cd /home/coder/project

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

if [ -f "yarn.lock" ]; then
    yarn
fi

if [ -f "package-lock.json" ]; then
    npm install
fi

/usr/bin/entrypoint.sh --bind-addr 0.0.0.0:8080 .
