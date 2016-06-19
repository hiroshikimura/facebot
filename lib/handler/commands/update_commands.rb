require 'slack'

module Handler::Commands

  class UpdateCommands < Handler::Command
    def proc(cmd)
      data = cmd[:data]
      post_params = {
        channel: data['channel'],
        text: '更新するからちょっと待ってて',
        as_user: true
      }
      client.chat_postMessage post_params
      `touch /var/tmp/facebot/update`
      `touch /var/tmp/facebot/restart`
      Kernel.exit
    end
  end
end

