class ChuckService
  include Singleton

  BASE_URL = "https://api.chucknorris.io".freeze

  def search(query)
    fetch(BASE_URL + "/jokes/search?query=#{URI.encode(query)}")
  end

  def categories
    fetch(BASE_URL + "/jokes/categories")
  end

  def from_category(category)
    fetch(BASE_URL + "/jokes/random?category=#{URI.encode(category)}")
  end

  def fetch(url)
    response = Net:HTTP.get_response(url)
    handle_response(response)
  end

  private

  def handle_response(response)
  end
end
