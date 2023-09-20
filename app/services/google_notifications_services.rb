require 'hangouts_chat'

class GoogleNotificationsServices

  def initialize
    @base_url = "https://chat.googleapis.com/v1/spaces/"
  end

  def notify_google_error(exception)
    if send_notifications_active?
      sender = HangoutsChat::Sender.new @base_url + ENV['NOTIFICATION_WEBHOOK']
      header = {
        title: exception.title,
        subtitle: exception.detail
      }
      sections = [{
        widgets: exception.source.map { |key, value| { keyValue: { topLabel: key, content: value } } }
      }]
      sender.card(header, sections)
    end
  end

  # Hardcoded Should create a module like lib/errors/not_found.rb
  def notify_card_message(data)
    if send_notifications_active?
      header = {
        title: data[:title],
        subtitle: data[:subtitle]
      }
      sections = [{
        widgets: data[:source].map { |key, value| { keyValue: { topLabel: key, content: value } } }
      }]
      sender = HangoutsChat::Sender.new @base_url + ENV['NOTIFICATION_WEBHOOK']
      sender.card(header, sections)
    end
  end

  def notify_simple_message(message)
    if send_notifications_active?
      sender = HangoutsChat::Sender.new @base_url + ENV['NOTIFICATION_WEBHOOK']
      sender.simple message
    end
  end

  private

  def send_notifications_active?
    ENV['NOTIFICATION_WEBHOOK'] && (ENV['SEND_NOTIFICATIONS'] == true || (ENV['SEND_NOTIFICATIONS'] || '').downcase == 'true')
    true
  end
end
