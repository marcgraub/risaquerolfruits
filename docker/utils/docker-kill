#!/bin/bash
function execute-command() {
  filter=$1

  docker kill $(docker ps --filter name=${filter} -q | head -1)
}

execute-command "$@"
