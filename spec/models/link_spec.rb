require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).optional }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'validates URL format' do
    expect(Link.new(name: 'invalid', url: 'http://invalid##host.com')).to_not be_valid
  end
end
