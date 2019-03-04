#!/bin/sh

#  WIRE Masternode docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

BASEDIR=$(dirname "$0")


if [ -f "$BASEDIR/../project_id" ]; then 
    PROJECT=$(sed 's/PROJECT=//g' "$BASEDIR/../project_id")
    PROJECT="--project-name $PROJECT"
fi 

container=$(docker-compose -f "$BASEDIR/../docker-compose.yml" $PROJECT ps -q mn 2> /dev/null)
TEMPLATE_VERSION=$(jq .version "$BASEDIR/../def.json")
STATUS="NOT RUNNING"
if [ -z "$container" ]; then 
    printf "STATUS: %s\n" "$STATUS"
    printf "TEMPLATE VERSION: %s\n" "$TEMPLATE_VERSION"
    exit
fi
docker exec "$container" /home/wire/get-node-info.sh
STATUS=$(docker ps --filter "id=$container" --format "{{.Status}}" --no-trunc 2> /dev/null)
if [ -z "$STATUS" ]; then
    STATUS="NOT RUNNING"
fi
printf "STATUS: %s\n" "$STATUS"
printf "TEMPLATE VERSION: %s\n" "$TEMPLATE_VERSION"