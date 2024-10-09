#!/bin/bash
function term() {
  filter=$1

  shell="bash"
  if [[ -n "$2" ]];
  then
    shell=$2
  fi

  additionalParameter=""
  if [[ -n "$3" ]];
  then
    additionalParameter=$3
  fi

  docker exec -it $(docker ps --filter name=${filter} -q | head -1) ${shell} ${additionalParameter}
}

term "$@"
