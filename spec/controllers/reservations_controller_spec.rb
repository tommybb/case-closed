require 'rails_helper'

RSpec.describe ReservationsController do
  describe '#index' do
    it 'returns revenue for each day for the last month' do
      get :index, params: { period: 30 }

      expect(response.body.apartments.count).to eq 30
    end
  end
end
