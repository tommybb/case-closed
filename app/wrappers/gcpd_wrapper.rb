require 'csv'

class GcpdWrapper
  def self.get_cases
    uri = URI('http://www.gotham-city.dev/gcpd/cases.csv')
    raw_csv = Net::HTTP.get(uri)
    CSV.parse(raw_csv)
  end
end
