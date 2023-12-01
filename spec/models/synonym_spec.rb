require 'rails_helper'

RSpec.describe Synonym, type: :model do
  it { should belongs_to(:word) }
end