#!/bin/bash

PARAMS=""

## NB: Even if people forget --prod, if we've got a resource group we definitely 
## are prod
resourceGroup=$(pulumi config get hasura-infra:resourceGroup 2>&1 > /dev/null || true)

if [[ -n $resourceGroup ]]; then
  export HASURA_PRODUCTION=''
  export HASURA_SCRIPT_PREFIX='infra-dev/lib'
else
  export HASURA_PRODUCTION='true'
  export HASURA_SCRIPT_PREFIX='infra-prod/lib'
fi

while (( "$#" )); do
  case "$1" in
    --prod)
      export HASURA_PRODUCTION='true'
      export HASURA_SCRIPT_PREFIX='infra-prod/lib'
      shift
      break
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"