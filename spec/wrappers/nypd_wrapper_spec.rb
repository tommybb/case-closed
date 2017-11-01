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
        {
          name: 'Joker escape',
          case_uid: '1002829',
          handler_email: 'james_gordon@gcpd.com',
          description: 'Joker just broke out of prison',
          priority: 'low'
        },
        {
          name: 'Joker escape',
          case_uid: '1002830',
          handler_email: 'james_gordon@gcpd.com',
          description: 'Joker just broke out of prison',
          priority: 'medium'
        },
        {
          name: 'Strange does something strange',
          case_uid: '1009199',
          handler_email: 'carlos_alvarez@gcpd.com',
          description: 'Hugo Strange suspected of strange experiments on sheeps',
          priority: 'high'
        }
      ])
    end
  end
end
