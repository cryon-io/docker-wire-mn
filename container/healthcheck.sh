#!/bin/sh

RESULT=$(curl -s -X POST -w "\n%{http_code}\n" --user "healthcheck:healthcheck_pass" --url http://localhost:10000 \
                                        --header 'Cache-Control: no-cache' \
                                        --header 'Content-Type: application/json' \
                                        --data '{"jsonrpc":"2.0","id":"healthcheck","method":"getblockchaininfo","params":[]}' \
                                        --silent -k)

HTTP_CODE=$(printf "%s" "$RESULT" | tail -n 1) 
if [ "$HTTP_CODE" = "200" ]; then exit 0; fi


CONTENT_LINES_COUNT=$(($(printf "%s" "$RESULT" | wc -l) - 1))
ERROR_MESSAGE=$(printf "%s" "$RESULT" | head -n $CONTENT_LINES_COUNT | jq .error.message -r)
# loading index is proper behaviour, so exit with 0
if [ "$ERROR_MESSAGE" = "Loading block index..." ]; then exit 0; fi

exit 1