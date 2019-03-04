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

FROM ubuntu:bionic

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl libjemalloc1 unzip jq -y

RUN apt-get -y install software-properties-common
RUN apt-add-repository -y ppa:bitcoin/bitcoin
RUN apt-get -y update
RUN apt-get -y install git libevent-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
    libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev libdb4.8-dev \
    libdb4.8++-dev libminiupnpc-dev virtualenv python-pip dh-autoreconf pkg-config build-essential \
    libssl-dev libzmq3-dev libgmp3-dev libminiupnpc-dev

ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh
HEALTHCHECK --interval=5s --timeout=3s --start-period=30s --retries=5 \
  CMD /healthcheck.sh

# create user
RUN adduser --disabled-login \
         --disabled-password \
         --gecos "" \
         --uid 16000 \
         wire

# copy necessary scripts
WORKDIR /home/wire/
COPY get-node.sh ./get-node.sh
COPY get-node-info.sh ./get-node-info.sh
COPY get-version.sh ./get-version.sh
COPY limits.conf ./limits.conf

# set execution rights
RUN chmod +x ./get-node.sh ./get-node-info.sh ./get-version.sh

# get latest wire binaries
RUN ./get-node.sh
RUN mv ./wired /usr/sbin/wired
RUN chmod +x /usr/sbin/wired ./wire-cli

# run wire masternode
USER wire
ENTRYPOINT [ "/usr/sbin/wired" ] 