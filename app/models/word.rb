class Word < ApplicationRecord
  has_many :synonyms, dependent: :destroy, inverse_of: :word
end
