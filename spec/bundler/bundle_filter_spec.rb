require 'spec_helper'

RSpec.describe BundleFilter do
  describe 'Version' do
    it 'has a version number' do
      expect(BundleFilter::VERSION).not_to be_nil
    end
  end

  describe 'Bundle Install' do
    context 'when running from Gemfile' do
      it 'remove useless information from bundle install' do
        skip 'Find a way to proper test bundle install output'
      end
    end
  end
end
