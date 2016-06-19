#!/bin/bash
PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

cd `dirname $0`
bundle exec whenever --update-crontab
