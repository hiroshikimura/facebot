#!/bin/bash
PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

cd `dirname $0`

while [ 1=1 ]
do
  bundle exec rake facebot:exec["./config/account.yml"]

  if [ -e /var/tmp/facebot/update ]; then
    git pull
    rm -rf /var/tmp/facebot/update
  fi

  if [ -e /var/tmp/facebot/restart ]; then
    rm -rf /var/tmp/facebot/restart
    echo '再起動します'
  else
    echo '終了します'
    break
  fi
done
