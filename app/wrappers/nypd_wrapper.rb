class NypdWrapper
  def initialize(url)
    @uri = URI(url)
  end

  def to_a
    raw_json = Net::HTTP.get(uri)
    JSON.parse(raw_json).map(&:symbolize_keys)
  end

  def self.cases
    new('http://www.new-york-city.dev/api/v1/cases.json').to_a
  end

  private

  attr_reader :uri
end
