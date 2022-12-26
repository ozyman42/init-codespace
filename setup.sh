#!/bin/bash
sudo apt-get update
sudo apt-get install tmux -y
npm i -g pnpm
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
node -e "p=require('path');f=require('fs');let l=p.resolve('/home/codespace/.vscode-remote/data/Machine/settings.json'); \
        let c=JSON.parse(f.readFileSync(l).toString());c['workbench.colorTheme']='Default Dark+'; \
        fs.writeFileSync(l, JSON.stringify(c, null, 2))"