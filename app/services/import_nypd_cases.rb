class ImportNypdCases < ImportCases
  private

  def wrapper_class
    NypdWrapper
  end

  def department_code
    'nypd'
  end
end
