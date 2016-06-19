require "#{Rails.root}/lib/procedure/idcf_task.rb"

namespace :idcf do
  desc 'idcf incident pool initialize'
  # 事前
  task :setup, [:config] => :environment do |task,args|
    p args
    p 'setup completed.'
    Procedure::IdcfTask
      .new(YAML.load_file(args[:config])[Rails.env])
      .execute_initialize()
  end

  desc 'idcf incident check'
  # 状況確認
  # 下記要領で実行
  # bundle exec rake idcf:exec['hoge']
  task :exec, [:config] => :environment do |task,args|
    p args
    p 'exec end'
    Procedure::IdcfTask
      .new(YAML.load_file(args[:config])[Rails.env])
      .execute_compare()
  end
end
