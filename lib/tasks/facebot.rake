require "#{Rails.root}/lib/handler/facebot_exec.rb"

namespace :facebot do
  desc 'facebot execution'
  # 事前
  task :exec, [:config] => :environment do |task,args|
    p args
    p 'setup completed.'
    Handler::FacebotExec
      .new(YAML.load_file(args[:config])[Rails.env])
      .exec
  end
end
