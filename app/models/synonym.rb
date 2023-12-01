class Synonym < ApplicationRecord
  belongs_to :word
  enum status: { pending: 0, approved: 1 }
end
