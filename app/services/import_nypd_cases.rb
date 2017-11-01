class ImportNypdCases < ImportCases
  def self.wrapper_class
    NypdWrapper
  end

  def self.department_code
    'nypd'
  end
end
