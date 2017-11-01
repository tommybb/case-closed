class ImportCases < Service
  def call
    wrapper_class.cases.each do |case_details|
      ImportCase.call(case_details)
    end
  end

  private

  def wrapper_class
    raise NotImplementedError
  end
end
