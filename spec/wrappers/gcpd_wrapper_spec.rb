RSpec.describe GcpdWrapper do
  describe '.cases' do
    it 'returns cases information from Gotham City police department' do
      csv = <<~CSV
        #100 Joker,James Gordon,james@gcpd.com,Joker just broke out of prison
        #101 Joker,James Gordon,james@gcpd.com,Joker just broke out of prison
        #102 Strange,Carlos Alvarez,carlos@gcpd.com,Hugo Strange... just wow!
      CSV
      stub_request(:get, 'http://www.gotham-city.dev/gcpd/cases.csv').
        to_return(body: csv)

      result = GcpdWrapper.cases

      expect(result).to match([
        have_attributes(
          name: 'Joker',
          uid: 'gcpd_100',
          officer_email: 'james@gcpd.com',
          officer_name: 'James Gordon',
          description: 'Joker just broke out of prison',
          important: false
        ),
        have_attributes(
          name: 'Joker',
          uid: 'gcpd_101',
          officer_email: 'james@gcpd.com',
          officer_name: 'James Gordon',
          description: 'Joker just broke out of prison',
          important: false
        ),
        have_attributes(
          name: 'Strange',
          uid: 'gcpd_102',
          officer_email: 'carlos@gcpd.com',
          officer_name: 'Carlos Alvarez',
          description: 'Hugo Strange... just wow!',
          important: false
        )
      ])
    end
  end
end
