class SearchService
  def initialize chuck_service: ChuckService.instance
    @chuck_service = chuck_service
  end

  def query(query)
    results = chuck_service.search(query)
    store_query_and_results(query, results)
    results
  end

  private

  attr_reader :chuck_service

  def store_query_and_results(query, results)
  end
end
