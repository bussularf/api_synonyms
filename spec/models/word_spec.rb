require 'rails_helper'

RSpec.describe Word, type: :model do
  it { should have_many(:synonyms) }
end