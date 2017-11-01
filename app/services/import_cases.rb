class ImportCases < Service
  def call
    wrapper_class.cases.each do |case_details|
      if (new_case = create_case(case_details))
        assign_hero(new_case)
        send_assignment_notification(new_case)
      end
    end
  end

  private

  def create_case(case_details)
    return false if Case.where(case_uid: case_details.uid).exists?
    Case.create(
      name: case_details.name,
      case_uid: case_details.uid,
      department_code: department_code,
      officer_email: case_details.officer_email,
      officer_name: case_details.officer_name,
      description: case_details.description,
      important: case_details.important
    )
  end

  def assign_hero(new_case)
    _, id = Hero.all.map{|hero| [hero.assigned_cases.count, hero.id] }.sort_by(&:first).first
    HeroCase.create!(hero_id: id, case_id: new_case.id)
  end

  def send_assignment_notification(new_case)
    NotificationsMailer.case_assignment_notification(new_case).deliver_later
  end

  def wrapper_class
    raise NotImplementedError
  end

  def department_code
    raise NotImplementedError
  end
end
