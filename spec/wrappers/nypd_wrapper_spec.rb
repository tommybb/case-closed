RSpec.describe NypdWrapper do
  describe '.cases' do
    it 'returns cases information from Gotham City police department' do
      json = <<~JSON
        [
          {"name":"Joker escape","case_uid":"1002829","handler_email":"james_gordon@gcpd.com","description":"Joker just broke out of prison","priority":"low"},
          {"name":"Joker escape","case_uid":"1002830","handler_email":"james_gordon@gcpd.com","description":"Joker just broke out of prison","priority":"medium"},
          {"name":"Strange does something strange","case_uid":"1009199","handler_email":"carlos_alvarez@gcpd.com","description":"Hugo Strange suspected of strange experiments on sheeps","priority":"high"}
        ]
      JSON
      stub_request(:get, 'http://www.new-york-city.dev/api/v1/cases.json').
        to_return(body: json)

      result = NypdWrapper.cases

      expect(result).to match([
        have_attributes(
          name: 'Joker escape',
          uid: 'nypd_1002829',
          officer_email: 'james_gordon@gcpd.com',
          officer_name: 'James Gordon',
          description: 'Joker just broke out of prison',
          important: false
        ),
        have_attributes(
          name: 'Joker escape',
          uid: 'nypd_1002830',
          officer_email: 'james_gordon@gcpd.com',
          officer_name: 'James Gordon',
          description: 'Joker just broke out of prison',
          important: false
        ),
        have_attributes(
          name: 'Strange does something strange',
          uid: 'nypd_1009199',
          officer_email: 'carlos_alvarez@gcpd.com',
          officer_name: 'Carlos Alvarez',
          description: 'Hugo Strange suspected of strange experiments on sheeps',
          important: true
        )
      ])
    end
  end
end
