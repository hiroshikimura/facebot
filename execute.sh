#!/bin/bash
cd `dirname $0`
bundle exec rake idcf:exec["./config/account.yml"]
