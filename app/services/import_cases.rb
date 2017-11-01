class ImportCases < Service
  def call
    wrapper_class.cases.each do |case_details|
      unless Case.where(case_uid: case_details.uid).exists?
        case_details = Case.create(
          name: case_details.name,
          case_uid: case_details.uid,
          department_code: department_code,
          officer_email: case_details.officer_email,
          officer_name: case_details.officer_name,
          description: case_details.description,
          important: case_details.important
        )
        _, id = Hero.all.map{|hero| [hero.assigned_cases.count, hero.id] }.sort_by(&:first).first
        HeroCase.create!(hero_id: id, case_id: case_details.id)
        NotificationsMailer.case_assignment_notification(case_details).deliver_later
      end
    end
  end

  private

  def wrapper_class
    raise NotImplementedError
  end

  def department_code
    raise NotImplementedError
  end
end
