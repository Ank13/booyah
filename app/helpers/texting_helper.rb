require 'net/http'
require 'uri'

module TextingHelper

  def send_order_success_sms(order)
    message = 
      "Hello #{order.user.first_name}, " +
      "your image has been received and you will receive it shortly in the mail! " +
      "Order total: $#{order.user_cost}."
    send_sms(order.user.cell, message)
  end

  def send_failed_order(user)
    message = 
      "Hello #{user.first_name}, " +
      "We are sorry, something went wrong and we could not complete your order! "
    send_sms(user.cell, message)
  end

  def send_no_image_response(user)
    message = 
      "Hello #{user.first_name}, " +
      "It appears there was no image attached to that message! "
    send_sms(user.cell, message)
  end

  def send_sms(to, message)
    url = URI.parse(
      "https://api.mogreet.com/moms/transaction.send?" +
      "client_id=4824" +
      "&token=8b229bb3e0a15ea0b5406ddc6d55be6f" +
      "&campaign_id=49137" +
      "&to=#{URI::encode(to)}" +
      "&message=#{URI::encode(message)}" +
      "&format=json"
    )
    response = Net::HTTP.start(url.host, use_ssl: true, ssl_version: 'SSLv3', verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      http.get url.request_uri
    end
  end

  def send_mms(message, media)

  end
end