class ImportGcpdCases < ImportCases
  private

  def wrapper_class
    GcpdWrapper
  end

  def department_code
    'gcpd'
  end
end
