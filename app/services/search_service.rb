class SearchService
  def initialize chuck_service: ChuckService.instance,
                 query_saver_service: QuerySaverService.new
                 
    @chuck_service = chuck_service
    @query_saver_service = query_saver_service
  end

  def query(query_param)
    if query = find_query(query_param)
      return query
    end

    results = chuck_service.search(query_param)
    store_query_and_results(query_param, results)
  end

  private

  attr_reader :chuck_service, :query_saver_service

  def find_query(query_param)
    Query.find_by("parameters @> ?", "query=>#{query_param}")
  end

  def store_query_and_results(query_param, results)
    query_saver_service.store("query", {query: query_param}, results)
  end
end
