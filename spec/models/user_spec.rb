require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  it { expect(user.authenticate!('admin', '$dm!nhola123')).to be_instance_of(described_class) }
end