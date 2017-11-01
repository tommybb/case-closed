class ImportCase < Service
  def initialize(case_details)
    @case_details = case_details
  end

  def call
    create_case and
      assign_hero and
      send_assignment_notification
  end

  private

  attr_reader :case_details, :case_created

  def create_case
    @case_created = if Case.where(case_uid: case_details.uid).exists?
                      false
                    else
                      Case.create(
                        name: case_details.name,
                        case_uid: case_details.uid,
                        department_code: case_details.department_code,
                        officer_email: case_details.officer_email,
                        officer_name: case_details.officer_name,
                        description: case_details.description,
                        important: case_details.important
                      )
                    end
  end

  def assign_hero
    _, id = Hero.all.map{|hero| [hero.assigned_cases.count, hero.id] }.sort_by(&:first).first
    HeroCase.create!(hero_id: id, case_id: case_created.id)
  end

  def send_assignment_notification
    NotificationsMailer.
      case_assignment_notification(case_created).
      deliver_later
  end
end
