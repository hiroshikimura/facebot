require 'slack'

module Handler::Commands

  class RestartCommands < Handler::Command
    def proc(cmd)
      data = cmd[:data]
      post_params = {
        channel: data['channel'],
        text: '再起動しますよっと',
        as_user: true
      }
      client.chat_postMessage post_params
      `touch /var/tmp/facebot/restart`
      Kernel.exit
    end
  end
end

