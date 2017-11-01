class ImportGcpdCases < ImportCases
  def self.wrapper_class
    GcpdWrapper
  end

  def self.department_code
    'gcpd'
  end
end
