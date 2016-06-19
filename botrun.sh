#!/bin/bash
cd `dirname $0`

while [ 1=1 ]
do
  #git pull
  bundle exec rake facebot:exec["./config/account.yml"]

  if [ -e /var/tmp/facebot_status ]; then
    echo '再起動します'
  else
    echo '終了します'
    break
  fi
done
