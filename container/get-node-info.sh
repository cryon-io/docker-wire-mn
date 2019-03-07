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

ver=$(./get-version.sh)
type="WIRE_MN"
mn_status="$(/home/wire/wire-cli masternode status 2>&1)"
if printf "%s" "$mn_status" | grep "error:"; then 
    mn_status=$(printf "%s" "$mn_status" | sed 's\error: \\g' | jq .message)
else 
    mn_status=$(printf "%s" "$mn_status" | jq .message)
fi

block_count="$(/home/wire/wire-cli getblockchaininfo 2>&1)"
if printf "%s" "$block_count" | grep "error:"; then 
    block_count=$(printf "%s" "$block_count" | sed 's\error: \\g' | jq .message)   
else 
    block_count="$(printf "%s" "$block_count" | jq .blocks)"
fi

sync_status="$(/home/wire/wire-cli mnsync status 2>&1)"
if printf "%s" "$sync_status" | grep "error:"; then 
    sync_status=$(printf "%s" "$sync_status" | sed 's\error: \\g' | jq .message) 
else 
    sync_status="$(printf "%s" "$sync_status" | jq .IsBlockchainSynced)"
fi

printf "\
TYPE: %s \n\
VERSION: %s \n\
MN_STATUS: %s \n\
BLOCKS: %s \n\
SYNCED: %s \n\
" "$type" "$ver" "$mn_status" "$block_count" "$sync_status"> /home/wire/.wire/node.info

printf "\
TYPE: %s \n\
VERSION: %s \n\
MN_STATUS: %s \n\
BLOCKS: %s \n\
SYNCED: %s \n\
" "$type" "$ver" "$mn_status" "$block_count" "$sync_status"