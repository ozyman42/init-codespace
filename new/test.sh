#!/bin/sh
docker build -t init_codespace .
docker run -it init_codespace