class NotificationsMailer < ApplicationMailer
  def case_assignment_notification(assigned_case)
    @officer_name = assigned_case.officer_name
    @case_name = assigned_case.name
    @hero_name = assigned_case.assigned_hero.name
    mail(
      to: assigned_case.officer_email,
      subject: "Your case is now handled by #{@hero_name}")
  end
end
