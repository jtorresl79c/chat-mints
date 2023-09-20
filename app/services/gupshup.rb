# Service to download ftp files from the server
class Gupshup
  def initialize
    promotion_file = ERB.new File.new("#{Rails.root}/promo_config.yml.erb").read
    @promo_config = YAML.safe_load promotion_file.result(binding)
    @testing = ENV['APP_ENV'] == 'development'

    @gupshup_base_url = "https://api.gupshup.io/sm/api/v1"

    # Get the variables from
    @app_name = @promo_config["gupshup_data"]["app_name"]
    @api_token = @promo_config["gupshup_data"]["api_token"]
    @provider_phone = @promo_config["gupshup_data"]["number"]

    if @testing
      # Arturo's gupshup sandbox account
      # @provider_phone = 917834811114
      # @app_name = 'PromotionTemplate'
      # @api_token = 'djg1e7oug9av6vj5ds8rename8eit0f4'
      # #

      # Mints.cloud gupshup account
      @app_name = "AngelPrueba"
      @api_token = "jgmd5laiivgi1frjz6lq5awadihfzyko"
      @provider_phone = 917_834_811_114
    end

    @headers = {
      apikey: @api_token,
      Accept: "application/x-www-form-urlencoded",
      "Content-Type": "application/x-www-form-urlencoded",
      "Cache-Control": "no-cache"
    }
  end

  def inbound_data(data)
    text = nil
    phone = data[:payload][:source] # Phone example: " 5216562631044 " [countryside]1[lada]
    type = data[:payload][:type]
    body = data[:payload][:payload]
    whatsapp_name = data[:payload][:sender][:name]
    phone_data = {
      phone: data[:payload][:sender][:phone],
      country_code: data[:payload][:sender][:country_code],
      dial_code: data[:payload][:sender][:dial_code]
    }

    case type
    when "text"
      text = body[:text]
    when "quick_reply"
      text = body[:text]
    when "button_reply"
      text = body[:reply]
    when "list_reply"
      text = body[:postbackText]
    when "image"
      # body[:url] example: https://filemanager.gupshup.io/fm/wamedia/demobot1/9e505c91-1311-4bf3-bf6b-2d56b69e358d
      body[:url].slice! "?fileName="
      text = "#{body[:url]}.jpg"
    # text example: https://filemanager.gupshup.io/fm/wamedia/demobot1/9e505c91-1311-4bf3-bf6b-2d56b69e358d.jpg
    # when 'video'
    #   text = body[:url] + '.mp4'
    # when 'sticker'
    #   text = body[:url] + '.mp3'
    # when 'audio'
    #   text = body[:url] + '.png' image/webp
    when "file"
      if body[:contentType] == "image/png" || body[:contentType] == "image/jpg" || body[:contentType] == "image/jpeg"
        body[:url].slice! "?fileName=#{body[:name]}"
        text = "#{body[:url]}.jpg"
      else
        return { valid: false, phone: phone, type: type, text: text, body: body, whatsapp_name: whatsapp_name,
                 phone_data: phone_data }
      end
    else
      # if california does not support this file type
      return { valid: false, phone: phone, type: type, text: text, body: body, whatsapp_name: whatsapp_name,
               phone_data: phone_data }
    end

    { valid: true, phone: phone, type: type, text: text, body: body, whatsapp_name: whatsapp_name,
      phone_data: phone_data }
  end

  def outbound_data(formatted_type_data)
    # TODO: Reuse this for the template outbound data
    type = formatted_type_data[:type]
    send(type.to_sym, formatted_type_data)
  end

  def format_template_data(index, params, type, extra_data = nil)
    # Production
    accepted_template_ids = %w[34f7e6c2-a463-4d23-8741-cf16a9df85a9 2bec0773-a6ac-4130-85af-f15c84663e62]
    if @testing
      # Sandbox
      # accepted_template_ids = ['b4880025-63e4-4df9-bb91-476d8abdb640']

      # Mints.cloud
      accepted_template_ids = %w[1c7b6841-18e6-4916-b867-b9aec1540bd6 3e34f51a-083c-49fe-9749-bb4bc8d8726e] # Template quick reply
    end
    {
      message: type == "text" ? nil : send("template_#{type}".to_sym, extra_data),
      template: {
        id: accepted_template_ids[index],
        params: params
      }
    }.compact
  end

  def send_message(message, contact_phone, template = nil)
    payload = {
      channel: "whatsapp",
      destination: contact_phone.delete_prefix("+"),
      message: message ? message.to_json : nil,
      source: @provider_phone,
      "src.name": @app_name,
      template: template ? template.to_json : nil
    }.compact

    url = template ? "#{@gupshup_base_url}/template/msg" : "#{@gupshup_base_url}/msg"

    opt_in_user(contact_phone.delete_prefix("+")) if template

    response = HTTParty.post(
      url,
      headers: @headers,
      body: payload
    )

    case response.code
    when 200..226
      response
    else
      error_message = {
        title: "Message could not be sent",
        subtitle: "An error occurred while sending a message",
        source: {
          class: "gupshup.rb",
          response: response.to_s,
          payload: payload.to_s,
          date: DateTime.now
        }
      }
      GoogleNotificationsServices.new.notify_card_message(error_message)
    end
  end

  def manage_event(event)
    destination = event[:payload][:destination] || nil
    status = event[:payload][:type] || nil
    payload = event[:payload][:payload] || nil

    begin
      case status
      when "enqueued"
        message_id = event[:payload][:payload][:whatsappMessageId]
        ProviderFailedMessage.create({ provider: "Gupshup", destination: destination, message_id: message_id,
                                       status: status, payload: payload })
      when "failed"
        message_id = event[:payload][:payload][:whatsappMessageId] || event[:payload][:id] || nil
        # Store it in the database
        ProviderFailedMessage.create({ provider: "Gupshup", destination: destination, message_id: message_id,
                                       status: status, payload: payload })
        # Notify a google spaces
        GoogleNotificationsServices.new.notify_simple_message("Gupshup.rb - manage_event()\nGupshup cannot send a message to: *#{destination}*\n *Reason*: #{event[:payload][:payload][:reason]}")
      # when 'read'
      #   #  Deactivated on Gupshup/dashboard/settings https://www.gupshup.io/whatsapp/dashboard then inside the settings of the app
      # when 'sent'
      #   #  Deactivated on Gupshup/dashboard/settings https://www.gupshup.io/whatsapp/dashboard then inside the settings of the app
      when "delivered"
        message_id = event[:payload][:id]
        message = ProviderFailedMessage.where(message_id: message_id).first
        message.delete unless message.nil? || message[:status] != "enqueued"
      # when 'delete'
      #   #  Deactivated on Gupshup/dashboard/settings https://www.gupshup.io/whatsapp/dashboard then inside the settings of the app
      # when 'others'
      #   #  Deactivated on Gupshup/dashboard/settings https://www.gupshup.io/whatsapp/dashboard then inside the settings of the app
      else
        GoogleNotificationsServices.new.notify_simple_message("GUPSHUP SERVICES:\nmanage_event()\nGupshup cannot send a message to: *#{destination}*\n *Reason*: #{event[:payload][:payload][:reason]}")
      end
    rescue StandardError => e
      GoogleNotificationsServices.new.notify_simple_message("GUPSHUP SERVICES:\nmanage_event()\nError: #{e}\n\n*Event*: #{event}")
    end
  end

  # def wallet
  #   "https://api.gupshup.io/wallet"
  # end

  # Structure formatting obtained via https://www.gupshup.io/developer/docs/bot-platform/guide/whatsapp-api-documentation#outboundMessage
  # This is most exclusively for sending the message
  def method_missing(data)
    # This is used mostly for the message formatting
    GoogleNotificationsServices.new.notify_simple_message("GUPSHUP SERVICES:\nmethod_missing()\nData: #{data}")
  end

  private

  # Session Messaging

  # PLAIN TEXT
  def text(data)
    # {
    #   "type": "text",
    #   "text": "Hi John, how are you?"
    # }
    {
      type: "text",
      text: data[:message]
    }
  end

  # MEDIA MESSAGES
  def image(data)
    # {
    #   "type": "image",
    #   "originalUrl": "https://www.buildquickbots.com/whatsapp/media/sample/jpg/sample01.jpg",
    #   "previewUrl": "https://www.buildquickbots.com/whatsapp/media/sample/jpg/sample01.jpg",
    #   "caption":"Sample image"
    # }
    {
      type: "image",
      originalUrl: data[:url],
      previewUrl: data[:url],
      caption: data[:message]
    }
  end

  # def document/file
  #   {
  #     "type": "file",
  #     "url": "https://www.buildquickbots.com/whatsapp/media/sample/pdf/sample01.pdf",
  #     "filename": "Sample functional resume"
  #   }
  # end

  # def audio
  #   {
  #     "type": "audio",
  #     "url": "https://www.buildquickbots.com/whatsapp/media/sample/audio/sample01.mp3"
  #   }
  # end

  # def video
  #   {
  #     "type": "video",
  #     "url":"https://www.buildquickbots.com/whatsapp/media/sample/video/sample01.mp4",
  #     "caption":"Sample video"
  #   }
  # end

  # def sticker
  #   {
  #     "type": "sticker",
  #     "url":"http://www.buildquickbots.com/whatsapp/stickers/SampleSticker01.webp"
  #   }
  # end

  # INTERACTIVE MESSAGES

  def list_reply(data)
    # {
    #   "type": "list",
    #   "title": "title text",
    #   "body": "body text",
    #   "msg-id": "list1",
    #   "globalButtons": [
    #     {
    #       "type": "text",
    #       "title": "Global button"
    #     }
    #   ],
    #   "items": [
    #     {
    #       "title": "first Section",
    #       "subtitle": "first Subtitle",
    #       "options": [
    #         {
    #           "type": "text",
    #           "title": "section 1 row 1",
    #           "description": "first row of first section description",
    #           "postbackText": "section 1 row 1 postback payload"
    #         },
    #         {
    #           "type": "text",
    #           "title": "section 1 row 2",
    #           "description": "second row of first section description",
    #           "postbackText": "section 1 row 2 postback payload"
    #         },
    #         {
    #           "type": "text",
    #           "title": "section 1 row 3",
    #           "description": "third row of first section description",
    #           "postbackText": "section 1 row 3 postback payload"
    #         }
    #       ]
    #     },
    #     {
    #       "title": "second section",
    #       "subtitle": "second Subtitle",
    #       "options": [
    #         {
    #           "type": "text",
    #           "title": "section 2 row 1",
    #           "description": "first row of second section description",
    #           "postbackText": "section 1 row 3 postback payload"
    #         }
    #       ]
    #     }
    #   ]
    # }
    {
      type: "list",
      title: "the_title",
      body: "the_body",
      msgid: "list1",
      globalButtons: [{ type: "text", title: "Concepcion" }],
      items: [
        {
          title: "Participation stencilled",
          subtitle: "Participation stencilled",
          options: [
            # { type: 'text', title: 'Suavely 4 rolls', description: '(1 participation)', postbackText: 'Suavely 4 rolls' }
          ]
        },
        {
          title: "Participation multiple",
          subtitle: "Participation multiple",
          options: [
            # { type: 'text', title: 'Suavely 16 rolls', description: '(2 participation)', postbackText: 'Suavely 16 rolls' },
            # { type: 'text', title: 'Suavely 32 rolls', description: '(3 participation)', postbackText: 'Suavely 32 rolls' }
          ]
        }
      ]
    }

  end

  def quick_reply(data)
    # construct the option buttons array
    formatted_reply_options = []
    if data[:reply_options].respond_to?(:each)
      data[:reply_options].each do |word|
        formatted_reply_options << { type: "text", title: word.capitalize }
      end
    else
      formatted_reply_options << { type: "text", title: data[:reply_options].capitalize }
    end
    {
      type: "quick_reply",
      content: {
        type: data[:subtype],
        url: (data[:subtype] == "image") && data[:url] ? data[:url] : nil,
        header: data[:header] || nil,
        text: data[:message],
        caption: data[:caption] || nil
      }.compact,
      options: formatted_reply_options
    }
  end

  # OTHER MESSAGES
  def location
    # {
    #   type: 'location',
    #   longitude: 43.43,
    #   latitude: 33.34,
    #   name: 'Name of the location',
    #   address: 'Postal address'
    # }
  end

  # Template Messaging

  def template_image(extra)
    {
      type: "image",
      image: {
        link: "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg"
      }
    }
  end

  def template_video(data)
    {
      type: "video",
      video: {
        link: "https://www.buildquickbots.com/whatsapp/media/sample/video/sample01.mp4"
      }
    }
  end

  def template_document(data)
    {
      type: "document",
      document: {
        link: "https://www.buildquickbots.com/whatsapp/media/sample/pdf/sample01.pdf",
        filename: "Sample functional resume"
      }
    }
  end

  def template_location(data)
    {
      type: "location",
      location: {
        longitude: "",
        latitude: ""
      }
    }
  end

  def template_call_to_action(data); end

  def template_quick_reply(data); end

  def opt_in_user(phone)
    HTTParty.post(
      "#{@gupshup_base_url}/app/opt/in/#{@promo_config["gupshup_data"]["app_name"]}",
      headers: { apikey: @api_token },
      body: { user: phone }
    )
  end

  def opt_in_list
    HTTParty.get(
      "#{@gupshup_base_url}/users/#{@promo_config["gupshup_data"]["app_name"]}",
      headers: headers
    )
  end
end
