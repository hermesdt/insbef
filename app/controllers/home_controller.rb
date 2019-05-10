class HomeController < ApplicationController
  before_action :fetch_categories, only: :index

  def index
  end

  private

  def fetch_categories
    @categories = ChuckService.instance.categories
  end
end
