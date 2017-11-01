class ImportGcpdCases
  def self.call
    GcpdWrapper.get_cases.each do |case_details|
      # Do not duplicate cases
      new_case = Case.where(case_uid: case_details.uid).first_or_initialize
      next if new_case.persisted?

      # Save case
      new_case.name = case_details.name
      new_case.department_code = 'gcpd'
      new_case.officer_email = case_details.officer_email
      new_case.officer_name = case_details.officer_name
      new_case.description = case_details.description
      new_case.important = case_details.important
      new_case.save


      # Assign hero to case
      hero_with_least_cases_id = Hero.
        all.
        map{|hero| [hero.assigned_cases.count, hero.id] }.
        sort_by(&:first).
        first.
        last
      Hero.find(hero_with_least_cases_id).assigned_cases << new_case

      # Notify officer that his case will be solved soon (unless spiderman was assigned
      # - hahaha, just kidding)
      NotificationsMailer.case_assignment_notification(new_case).deliver_later
    end
  end
end
