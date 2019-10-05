#!/bin/bash

export SERVER_IP=$1

pkill -9 ruby

echo "****************************************************************"
echo "          Abrir desde el telefono: $SERVER_IP:5000"
echo "****************************************************************"

echo "*** starting local web server"
ruby -run -e httpd -- -p 5000 ./public &

echo "*** starting websockets servers"
bundle exec ruby server.rb &

wait
