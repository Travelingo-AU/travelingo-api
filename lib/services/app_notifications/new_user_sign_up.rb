module AppNotifications

  # TODO: handle Slack errors: https://api.slack.com/changelog/2016-05-17-changes-to-errors-for-incoming-webhooks
  class NewUserSignUp

    include SemanticLogger::Loggable

    WEBHOOK_URL        = ENV![:NEW_USER_SIGN_UP_WEBHOOK_URL]
    TEMPLATE_FILE_PATH = "#{__dir__}/new_user_sign_up.md.erb"
    DEBUG_MESSAGE_DIR_PATH = File.join(ENV!.app_root, 'tmp', 'slack_notifications')

    private_class_method :new

    MalformedAuthHeaderValue = Class.new(Authentication::AuthError)

    def initialize(logger: nil, debug_payload: false)
      @logger = logger if logger
      @debug_payload = debug_payload
    end

    def self.notify_about_new(user, **opts)
      new(**opts).notify_about_new(user)
    end

    def notify_about_new(user)
      kargs = {text:        build_message_text(user),
               attachments: build_attachments(user)}

      logger.debug("Slack payload", slack_payload: kargs)
      debug_payload(kargs) if debug_payload?
      notifier.post(**kargs)
    end

    # By defaults attachments are not markdown-formatted, forcing by passing
    # `mrkdwn_in`: ["text"]. Ses: https://api.slack.com/docs/message-formatting#message_formatting
    def build_message_text(user)
      "*New user sign-up! [ID: #{user.id}]*"
    end

    # More on attachments: https://api.slack.com/docs/message-attachments
    def build_attachments(user)
      edit_link = build_edit_user_link(user)
      show_link = build_show_user_link(user)

      [{color:       'good',
        mrkdwn_in:   ['text'],
        author_name: user.full_name,
        author_link: show_link,
        author_icon: user.picture_url,
        text:        build_attachment_text(user),
        footer:      "Congrats with your #{User.count} user!",
        "actions":   [
                       {"type":  "button",
                        "text":  "Show in admin panel",
                        "url":   show_link,
                        "style": "primary"},
                       {"type":  "button",
                        "text":  "Edit in admin panel",
                        "url":   edit_link,
                        "style": "danger"}
                     ]
       }]

    end

    def build_attachment_text(user)
      ERB.new(File.read(TEMPLATE_FILE_PATH)).result(binding).strip
    end

    def build_show_user_link(user)
      "#{ENV![:APP_URL]}/admin/users/#{user.id}"
    end

    def build_edit_user_link(user)
      "#{build_show_user_link(user)}/edit"
    end

    def debug_payload?
      @debug_payload == true
    end

    def debug_payload(payload)
      return unless defined?(Launchy)
      Dir.mkdir(DEBUG_MESSAGE_DIR_PATH) unless Dir.exists?(DEBUG_MESSAGE_DIR_PATH)

      json = JSON.pretty_generate(payload)
      tmp_file_path = File.join(DEBUG_MESSAGE_DIR_PATH, "new_user_sign_up.json")
      logger.debug("Temp file name path: #{tmp_file_path}")

      File.write(tmp_file_path, json)
      Launchy.open("file:///#{tmp_file_path}")
    end

    def notifier
      @notifier ||= Slack::Notifier.new(WEBHOOK_URL) do
        defaults(channel: '#new_users', username: 'Bob')
        # We don't need HTML here, more info https://github.com/stevenosloan/slack-notifier#middleware
        middleware(
          format_message:     {formats: [:markdown]},
          format_attachments: {formats: [:markdown]}
        )
      end
    end
  end
end
