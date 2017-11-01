RSpec.describe GcpdWrapper do
  describe '.get_cases' do
    it 'returns cases information from Gotham City police department' do
      csv = <<~CSV
        #100 Joker,James Gordon,james@gcpd.com,Joker just broke out of prison
        #101 Joker,James Gordon,james@gcpd.com,Joker just broke out of prison
        #102 Strange,Carlos Alvarez,carlos@gcpd.com,Hugo Strange... just wow!
      CSV
      stub_request(:get, 'http://www.gotham-city.dev/gcpd/cases.csv').
        to_return(body: csv)

      result = GcpdWrapper.get_cases

      expect(result).to match([
        ['#100 Joker', 'James Gordon', 'james@gcpd.com', 'Joker just broke out of prison'],
        ['#101 Joker', 'James Gordon', 'james@gcpd.com', 'Joker just broke out of prison'],
        ['#102 Strange', 'Carlos Alvarez', 'carlos@gcpd.com', 'Hugo Strange... just wow!']
      ])
    end
  end
end
