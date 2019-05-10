class QuerySaverService
  def store(query_type, parameters, results)
    query = Query.create!(query_type: query_type, parameters: parameters)

    results.each do |result|
      query.results.create!(text: result)
    end
  end
end
