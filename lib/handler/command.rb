module Handler
  class Command
    attr_reader :config
    attr_reader :client

    def initialize(c, cl)
      @config = c
      @client = cl
    end
    #def proc(cmd, arguments)
    def proc(cmd)
      data = cmd[:data]
      post_params = {
        channel: data['channel'],
        text: "そんなコマンド無いよ #{cmd[:cmd]}",
        as_user: true
      }
      client.chat_postMessage post_params
    end

    def self.load_command_handler
      # ロード処理
      Dir[File.expand_path("#{Rails.root}/lib/handler/commands", __FILE__) << '/*.rb'].each do |file|
        require file
      end
    end

  end
end
