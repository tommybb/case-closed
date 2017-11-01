require 'csv'

class GcpdWrapper
  def self.cases
    uri = URI('http://www.gotham-city.dev/gcpd/cases.csv')
    raw_csv = Net::HTTP.get(uri)
    CSV.parse(raw_csv).map do |row|
      case_uid = row[0].split(' ')[0][1..-1]
      case_name = row[0].split(' ')[1..-1].join(' ')

      OpenStruct.new(
        name: case_name,
        uid: 'gcpd_' + case_uid,
        officer_email: row[2],
        officer_name: row[1],
        description: row[3],
        important: false
      )
    end
  end
end
