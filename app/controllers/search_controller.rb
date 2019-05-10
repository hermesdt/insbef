class SearchController < ApplicationController
  def index
    @results = search_service.query(query_param)
  end

  private

  def search_service
    SearchService.new
  end

  def query_param
    @query ||= params.require(:query)
  end
end
