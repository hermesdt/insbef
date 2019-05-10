require 'spec_helper'

RSpec.describe ChuckService do
  it "returns always the same instance" do
    instance = ChuckService.instance
    expect(ChuckService.instance).to be(instance)
  end

  context "response code != 200" do
    let(:error_response) do
      double(:response, code: "404", body: "")
    end

    it "raises an exception" do
      expect(ChuckService.instance).to receive(:request).and_return(error_response)

      expect {
        ChuckService.instance.fetch("http://someurl")
      }.to raise_error(ChuckServiceException) do |error|
        expect(JSON.parse(error.message)["code"]).to eq("404")
      end
    end
  end

  context "response type != 'application/json'" do
    let(:error_response) do
      double(:response, code: "200", body: "", content_type: "text/plain")
    end

    it "raises an exception" do
      expect(ChuckService.instance).to receive(:request).and_return(error_response)

      expect {
        ChuckService.instance.fetch("http://someurl")
      }.to raise_error(ChuckServiceException) do |error|
        expect(JSON.parse(error.message)["code"]).to eq("200")
        expect(JSON.parse(error.message)["message"]).to eq("unkown content type")
      end
    end
  end

  describe "#search" do
    let(:response) do
      double(:response,
        code: "200",
        content_type: "application/json",
        body: {
          "total": 1,
          "result": [{title: "hey"}]
        }.to_json)
    end

    it "returns the results" do
      expect(ChuckService.instance).to receive(:fetch).
        with("https://api.chucknorris.io/jokes/search?query=kicks").
        and_call_original
      expect(ChuckService.instance).to receive(:request).and_return(response)

      expect(ChuckService.instance.search("kicks")).to eq(
        [{"title" => "hey"}]
      )
    end
  end

  describe "#categories" do
    let(:response) do
      double(:response,
        code: "200",
        content_type: "application/json",
        body: [
          "explicit", "dev"
        ].to_json)
    end

    it "returns the results" do
      expect(ChuckService.instance).to receive(:fetch).
        with("https://api.chucknorris.io/jokes/categories").
        and_call_original
      expect(ChuckService.instance).to receive(:request).and_return(response)

      expect(ChuckService.instance.categories).to eq(
        ["explicit", "dev"]
      )
    end
  end

  describe "#random" do
    let(:response) do
      double(:response,
        code: "200",
        content_type: "application/json",
        body: {
          "category": nil,
          "icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
          "id": "vb32vy6eSlWKVkS6Qcgnhw",
          "url": "https://api.chucknorris.io/jokes/vb32vy6eSlWKVkS6Qcgnhw",
          "value": "Chuck Norris once played with blocks as a toddler. These blocks are known to us today as Stonehenge"
        }.to_json)
    end

    it "returns the results" do
      expect(ChuckService.instance).to receive(:fetch).
        with("https://api.chucknorris.io/jokes/random").
        and_call_original
      expect(ChuckService.instance).to receive(:request).and_return(response)

      expect(ChuckService.instance.random["category"]).to be_nil
    end
  end

  describe "#from_category" do
    let(:response) do
      double(:response,
        code: "200",
        content_type: "application/json",
        body: {
          "category": [
            "dev"
          ],
          "icon_url": "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
          "id": "poqerqlpqz2en3hacikbjw",
          "url": "https://api.chucknorris.io/jokes/poqerqlpqz2en3hacikbjw",
          "value": "Chuck Norris doesn't use reflection, reflection asks politely for his help."
        }.to_json)
    end

    it "returns the results" do
      expect(ChuckService.instance).to receive(:fetch).
        with("https://api.chucknorris.io/jokes/random?category=dev").
        and_call_original
      expect(ChuckService.instance).to receive(:request).and_return(response)

      expect(ChuckService.instance.from_category("dev")["category"]).to eq(["dev"])
    end
  end
end
