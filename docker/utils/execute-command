#!/bin/bash
function execute-command() {
  filter=$1

  user=""
  if [[ -n "$2" ]];
  then
    user="--user $2"
  fi

  shell="bash"
  if [[ -n "$3" ]];
  then
    shell=$3
  fi

  additionalParameter=""
  if [[ -n "$4" ]];
  then
    additionalParameter=$4
  fi

  prefix=""
  if [[ "$(expr substr "$(uname -s)" 1 5)" == "MINGW" ]]; then
    prefix="winpty"
  fi
  ${prefix} docker exec -ti ${user} $(docker ps --filter name=${filter} -q | head -1) ${shell} "${additionalParameter}"
}
#-ti dd4889d0c542 sh -c "ls"
execute-command "$@"
