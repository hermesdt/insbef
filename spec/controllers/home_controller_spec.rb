require 'rails_helper'

RSpec.describe HomeController, type: :controller, vcr: true do
  describe "#index" do
    it "prints all categories" do
      VCR.use_cassette("home_controller_index") do
        get :index
      end
      
      expect(assigns(:categories)).to eq(["explicit", "dev", "movie",
        "food", "celebrity", "science", "sport", "political",
        "religion", "animal", "history", "music", "travel", "career",
        "money", "fashion"])
    end
  end
end
