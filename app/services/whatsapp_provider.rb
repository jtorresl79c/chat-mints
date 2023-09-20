# Service to download ftp files from the server
class WhatsappProvider
  attr_accessor :provider

  def initialize(provider)
    supported_providers = ['gupshup']
    @provider = supported_providers.include?(provider.downcase) ? provider.camelize.constantize.new : Gupshup.new # Gupshup by default
  end

  def inbound_data(data)
    @provider.inbound_data(data)
  end

  def outbound_data(data)
    @provider.outbound_data(data)
  end

  def send_message(message, number, template = nil)
    @provider.send_message(message, number, template)
  end

  def format_template_data(index, params, type)
    @provider.format_template_data(index, params, type)
  end

  def manage_event(event)
    @provider.manage_event(event)
  end

end
