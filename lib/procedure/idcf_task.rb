require 'mechanize'
require 'nkf'
require 'slack-notifier'

module Procedure
  class FileNotFoundError < StandardError; end

  class SlackIf

    attr_reader :cfg
    attr_reader :slk

    def initialize(config)
      @cfg = config
      @slk = Slack::Notifier.new(cfg['webhookurl'])
    end

    def post(incidents)
      msg = ""
      incidents.keys.each{|key|
        e = incidents[key]
        t = e[:ticket]
        d = e[:date]
        b = e[:title]
        u = e[:url]
        m = <<-EOC
--------------------------------------
チケット番号： #{t}
日付： #{d}
タイトル： #{b}
URL : #{u}
        EOC
        msg = "#{msg}#{m}"
      }
      begin
        slk.ping(msg) if incidents.present?
        slk.ping("なにもないよ") unless incidents.present?
      rescue => e
        p e
      end
    end
  end

  class IdcfTask

    # login URL
    LOGIN_URL = 'https://idcfcloud.com/'.freeze
    INCIDENT_URL = 'https://console.idcfcloud.com/support/incident/'.freeze
    NKFOPT = "-Ww".freeze

    attr_reader :cfg
    attr_reader :redis
    attr_reader :sender

    def initialize(config)
      begin
        @cfg = YAML.load_file(config)[Rails.env]
        @redis = redis_cli()
        @sender = SlackIf.new(@cfg)
      rescue => e
        raise FileNotFoundError, "file not found #{config}"
      end
    end

    def redis_cli
      # 個々の設定は適当
      Redis.new(:host => "localhost", :port => 6379, :db => 3)
    end

    def execute_initialize
      # 認証後のagentを取得
      incident_list = retrieve_incident( Mechanize.new )

      # redisへ保存
      write_incident(incident_list)
    end

    def write_incident(incidents)
      redis.set(
        'incident',
        {
          'date' => Date.new(),
          'info' => incidents
        }.to_json
      )
    end

    def read_incident
      incidents = {}
      begin
        info = JSON.parse( redis.get('incident') )
        p "last update date=#{info['date']}"
        incidents = info['info']
      rescue => e
        # ない場合
      end
      incidents
    end

    def execute_compare
      # 掲載中のインシデント
      current_incidents = retrieve_incident(Mechanize.new)
      # 最後に取得したインシデント
      last_incidents = read_incident()
      # 新しい物を抽出
      what_new = compare_incident(current_incidents, last_incidents)

      sender.post(what_new)
    end

    def retrieve_incident(agent)
      # credentials
      username = cfg['username']
      password = cfg['password']

      # ログイン画面に遷移
      agent.get(LOGIN_URL)
      # 認証処理
      agent.page.form_with(:id => 'fm1') { |f|
        f.field_with(:name => 'username').value = username
        f.field_with(:name => 'password').value = password
        f.click_button # submit
      }


      # 障害情報ページ取得
      agent.get(INCIDENT_URL)
      incident_list = {};
      agent.page.search('table.table-responsive#datatables tbody tr').map{|e|
        incident_id = e.search('td[1]').attribute('id').text.gsub(/^ticket/,"")
        ticket_val = NKF.nkf(NKFOPT, e.search('td[1]').text).gsub(/^\s+|\s+$/,"")
        date_val   = NKF.nkf(NKFOPT, e.search('td[2]').text).gsub(/^\s+|\s+$/,"")
        title_val  = NKF.nkf(NKFOPT, e.search('td[3]').text).gsub(/^\s+|\s+$/,"")
        incident_list[incident_id] = {
          # ticket id
          ticket: ticket_val,
          # date
          date:   date_val,
          # title
          title:  title_val,
          # url
          url: "https://console.idcfcloud.com/support/incident/?id=#{incident_id}"
        }
      }

      incident_list
    end

    def refresh_incident(agent)
    end

    def compare_incident(current,last)
      what_new = {}
      current.each{|key,value|
        what_new[key] = value unless last.has_key?(key)
      }
      write_incident(current)
      what_new
    end
  end
end
