class Query < ApplicationRecord
  has_many :results, dependent: :delete_all
end
