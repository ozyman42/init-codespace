#!/bin/sh
# https://stackoverflow.com/questions/21200304/docker-how-to-show-the-diffs-between-2-images
# https://www.baeldung.com/ops/docker-differences-between-images
IMAGE_ONE=$1
IMAGE_TWO=$2
container-diff diff daemon://$IMAGE_ONE daemon://$IMAGE_TWO --type=file
