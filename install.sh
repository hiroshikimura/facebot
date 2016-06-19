sudo apt-get install curl git
sudo apt-get install g++ make zlib1g-dev libssl-dev libreadline-dev libyaml-dev sudo apt-get install libxml2-dev libxslt-dev
sudo apt-get install sqlite3 libsqlite3-dev
sudo apt-get install redis-server redis-tools
sudo mkdir -p /var/tmp/facebot
sudo chmod 777 /var/tmp/facebot

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build ~/.rbenv/plugins/ruby-build
echo 'PATH=${HOME}/.rbenv/bin:${PATH}' >> ~/.bashrc
echo 'eval "eval "$(rbenv init -)"' >> ~/.bashrc
. ~/.bashrc

rbenv install 2.3.1
rbenv global 2.3.1
gem install bundler
bundle install --path=vendor/bundle --local
