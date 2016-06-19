require 'slack'
require "#{Rails.root}/lib/procedure/idcf_task.rb"

module Handler::Commands

  class ConfirmCommands < Handler::Command
    def proc(cmd)
      Procedure::IdcfTask
        .new(config)
        .confirm
    end
  end
end

