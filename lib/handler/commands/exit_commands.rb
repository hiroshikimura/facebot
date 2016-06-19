require 'slack'

module Handler::Commands

  class ExitCommands < Handler::Command
    def proc(cmd)
      data = cmd[:data]
      post_params = {
        channel: data['channel'],
        text: '終了しますよっと',
        as_user: true
      }
      client.chat_postMessage post_params
      Kernel.exit
    end
  end
end

