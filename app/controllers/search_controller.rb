class SearchController < ApplicationController
  def index
    @query = search_service.query(query_param)
    @results = @query.results.page(params[:page])
  end

  private

  def search_service
    SearchService.new
  end

  def query_param
    @query ||= params.require(:query)
  end
end
