require 'rails_helper'

RSpec.describe FetchReservationsWrapper do
  describe '#import_all' do
    it 'saves all reservations to database and returns true' do
      json = {
        data: [
          {
            reservationId: '01234',
            checkinDate: '2018-06-11',
            checkoutDate: '2018-06-16',
            guestName: 'Tony Stark',
            roomId: '887'
          }
        ]
      }
      api_fetcher = double('api_fetcher', all_reservations: json)

      allow(API::FetchReservationsFromX).to receive(:new).and_return api_fetcher

      expect_any_instance_of(api_fetcher).to receive(:all_reservations)
      expect{ FetchReservationsWrapper.import_all }.to change { Reservations.count }.by 1
    end
  end
end
