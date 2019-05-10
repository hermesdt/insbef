class Result < ApplicationRecord
  belongs_to :query

  def from_json
    @json ||= JSON.parse(self.text)
  end
end
