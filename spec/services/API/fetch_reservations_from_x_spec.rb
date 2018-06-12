require 'rails_helper'

RSpec.describe API::FetchReservationsFromX do

  describe '#all_reservations' do
    it 'fetches all reservations data from external API endpoint' do
      allow(ENV).to receive(:RESERVATIONS_API_URL).and_return('https://reservations')
      allow(ENV).to receive(:RESERVATIONS_API_TOKEN).and_return('asdfsfdasd086a76d444asd6544')

      stub_request(:get, "#{ENV[:RESERVATIONS_API_URL]}/all_reservations").
        with(:headers => {
          'Content-Type'=>'application/json',
          'X-Api-Key' => "#{ENV[:RESERVATIONS_API_TOKEN]}"
        }).
        to_return(:status => 200, :body => "{
                                            data: [
                                              {
                                              reservationId: '01234',
                                              checkinDate: '2018-06-11',
                                              checkoutDate: '2018-06-16',
                                              guestName: 'Tony Stark',
                                              roomId: '887'
                                              }
                                            ]
                                          }")

      response = FetchReservationsFromX.new.all_reservations

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to include({
                                                     reservationId: '01234',
                                                     checkinDate: '2018-06-11',
                                                     checkoutDate: '2018-06-16',
                                                     guestName: 'Tony Stark',
                                                     roomId: '887'
                                                   })
    end
  end

  describe '#reservation' do
    it 'fetches reservation with specific ID from external API endpoint' do
      allow(ENV).to receive(:RESERVATIONS_API_URL).and_return('https://reservations')
      allow(ENV).to receive(:RESERVATIONS_API_TOKEN).and_return('asdfsfdasd086a76d444asd6544')

      stub_request(:get, "#{ENV[:RESERVATIONS_API_URL]}/reservation/01234").
        with(:headers => {
          'Content-Type'=>'application/json',
          'X-Api-Key' => "#{ENV[:RESERVATIONS_API_TOKEN]}"
        }).
        to_return(:status => 200, :body => "{
                                            reservationId: '01234',
                                            checkinDate: '2018-06-11',
                                            checkoutDate: '2018-06-16',
                                            guestName: 'Tony Stark',
                                            roomId: '887',
                                            rates: {
                                              '2018-06-11' => 100,
                                              '2018-06-12' => 200,
                                              '2018-06-13' => 250,
                                              '2018-06-14' => 250,
                                              '2018-06-15' => 100,
                                            },
                                            total: 900
                                            }")

      response = FetchReservationsFromX.new.reservation(01234)

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to include({
                                                     reservationId: '01234',
                                                     checkinDate: '2018-06-11',
                                                     checkoutDate: '2018-06-16',
                                                     guestName: 'Tony Stark',
                                                     roomId: '887',
                                                     rates: {
                                                       '2018-06-11' => 100,
                                                       '2018-06-12' => 200,
                                                       '2018-06-13' => 250,
                                                       '2018-06-14' => 250,
                                                       '2018-06-15' => 100,
                                                     },
                                                     total: 900
                                                   })
    end
  end
end
