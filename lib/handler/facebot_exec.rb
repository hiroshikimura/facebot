require 'slack'
require "#{Rails.root}/lib/handler/command.rb"

module Handler
  class FacebotExec
    attr_reader :cfg

    def initialize(config)
      # 設定保持
      @cfg = config
      # slack botの初期化
      Slack.configure do |config|
        config.token = cfg['token']
      end

      # コマンドハンドラのロード
      Handler::Command.load_command_handler
    end

    def find_handler(cmd)
      cmd = cmd.downcase.capitalize
      q = nil
      begin
        q = Object.const_get("Handler::Commands::#{cmd}Commands")
      rescue => e
        q = Handler::Command
      end
      q
    end

    def valid_bot?(user, client)
      user = user.gsub(/^\<\@/, '')
      user = user.gsub(/\>:$/, '')
      user_info = client.users_info({user: user})
      user_info['ok'] && cfg['botname'] == user_info['user']['name']
    end

    def exec
      #client = Slack::RealTime::Client.new
      receiver = Slack::realtime
      client = Slack.client

      # 接続時
      receiver.on :hello do |data|
        p "facebot、起動したっす"
      end

      receiver.on :message do |data|
        txt = data['text']
        next unless txt.present?
        tokens = txt.split(' ')

        #" <@(\w+)>:"
        user = tokens.shift
        next unless valid_bot?(user, client)

        cmd = tokens.shift
        find_handler(cmd)
          .new(cfg, client)
          .proc({
            cmd:  cmd,
            data: data
          })
      end

      p "起動するよ"
      receiver.start
    end
  end
end
