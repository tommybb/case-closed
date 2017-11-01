class ImportNypdCases
  def self.call
    new.call
  end

  def call
    NypdWrapper.cases.each do |kejs|
      unless Case.where(case_uid: "nypd_#{kejs[:case_uid]}").exists?
        kejs = Case.create(
          name: kejs[:name],
          case_uid: "nypd_#{kejs[:case_uid]}",
          department_code: 'nypd',
          officer_email: kejs[:handler_email],
          officer_name: kejs[:handler_email].split("@").first.split("_").map(&:capitalize).join(" "),
          description: kejs[:description],
          important: kejs[:priority] == 'high'
        )
        _, id = Hero.all.map{|hero| [hero.assigned_cases.count, hero.id] }.sort_by(&:first).first
        HeroCase.create!(hero_id: id, case_id: kejs.id)
        NotificationsMailer.case_assignment_notification(kejs).deliver_later
      end
    end
  end
end
