require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET /index" do
    it "stores the query in the DB" do
      get :index, params: {query: "kicks"}

      query = Query.last
      expect(query.query_type).to eq("query")
      expect(query.parameters).to eq({"query" => "kicks"})
      expect(query.results.count).to eq(114)
    end

    it "assigns the results" do
      get :index, params: {query: "kicks"}

      expect(assigns(:results).size).to eq(114)
      expect(assigns(:results).first).to eq({
        "category" => nil,
        "icon_url" => "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
        "id" => "tjq8lv6lqi-uoo5cxiu2oa",
        "url" => "https://api.chucknorris.io/jokes/tjq8lv6lqi-uoo5cxiu2oa",
        "value" => "Chuck Norris can be unlocked on the hardest level of Tekken. But only Chuck Norris is skilled enough to unlock himself. Then he roundhouse kicks the Playstation back to Japan."
      })
    end
  end
end
