class ImportNypdCases
  def self.call
    new.call
  end

  def call
    NypdWrapper.cases.each do |kejs|
      unless Case.where(case_uid: kejs.uid).exists?
        kejs = Case.create(
          name: kejs.name,
          case_uid: kejs.uid,
          department_code: 'nypd',
          officer_email: kejs.officer_email,
          officer_name: kejs.officer_name,
          description: kejs.description,
          important: kejs.important
        )
        _, id = Hero.all.map{|hero| [hero.assigned_cases.count, hero.id] }.sort_by(&:first).first
        HeroCase.create!(hero_id: id, case_id: kejs.id)
        NotificationsMailer.case_assignment_notification(kejs).deliver_later
      end
    end
  end
end
