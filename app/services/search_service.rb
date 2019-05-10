class SearchService
  def initialize chuck_service: ChuckService.instance,
                 query_saver_service: QuerySaverService.new
                 
    @chuck_service = chuck_service
    @query_saver_service = query_saver_service
  end

  def query(query)
    results = chuck_service.search(query)
    store_query_and_results(query, results)
    results
  end

  private

  attr_reader :chuck_service, :query_saver_service

  def store_query_and_results(query, results)
    query_saver_service.store("query", {query: query}, results)
  end
end
