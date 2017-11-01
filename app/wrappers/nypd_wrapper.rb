class NypdWrapper
  def initialize(url)
    @uri = URI(url)
  end

  def to_a
    raw_json = Net::HTTP.get(uri)
    JSON.parse(raw_json).map do |row|
      OpenStruct.new(
        name: row['name'],
        uid: 'nypd_' + row['case_uid'],
        department_code: 'nypd',
        officer_email: row['handler_email'],
        officer_name: row['handler_email'].
          split('@').
          first.
          split('_').
          map(&:capitalize).
          join(' '),
        description: row['description'],
        important: row['priority'] == 'high'
      )
    end
  end

  def self.cases
    new('http://www.new-york-city.dev/api/v1/cases.json').to_a
  end

  private

  attr_reader :uri
end
