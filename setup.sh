#!/bin/bash
cd `dirname $0`
bundle exec rake idcf:setup["./config/account.yml"]
