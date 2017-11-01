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
    hero_with_the_least_cases = Hero.
      left_outer_joins(:hero_cases).
      group('heros.id').
      order('COUNT(hero_cases.id) ASC').
      first

    hero_with_the_least_cases.assigned_cases << case_created
  end

  def send_assignment_notification
    NotificationsMailer.
      case_assignment_notification(case_created).
      deliver_later
  end
end
