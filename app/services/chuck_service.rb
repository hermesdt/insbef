require 'net/https'

OK = "200".freeze
JSON_CONTENT_TYPE = "application/json".freeze
class ChuckServiceException < StandardError;end

class ChuckService
  include Singleton

  BASE_URL = "https://api.chucknorris.io".freeze

  def search(query)
    fetch(BASE_URL + "/jokes/search?query=#{URI.encode(query)}")["result"]
  end

  def random
    fetch(BASE_URL + "/jokes/random")
  end

  def categories
    fetch(BASE_URL + "/jokes/categories")
  end

  def from_category(category)
    fetch(BASE_URL + "/jokes/random?category=#{URI.encode(category)}")
  end

  def fetch(url)
    response = request(url)
    Rails.logger.debug("received response code=#{response.code}, body=#{response.body[0..200]}...")
    handle_response(response)
  end

  private

  # :nocov:
  def request(url)
    Net::HTTP.get_response(URI.parse(url))
  end
  # :nocov:

  def handle_response(response)
    if response.code != OK
      raise ChuckServiceException.new({
        code: response.code,
        message: "server error"
      }.to_json)
    end

    if response.content_type != JSON_CONTENT_TYPE
      raise ChuckServiceException.new({
        code: response.code,
        message: "unkown content type"
      }.to_json)
    end

    JSON.parse(response.body)
  end
end
