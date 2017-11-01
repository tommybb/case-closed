RSpec.describe ImportGcpdCases do
  describe '.call' do
    it 'imports new cases idempotently, verifying uniqueness by case uid' do
      create(:hero)
      allow(GcpdWrapper).to receive(:get_cases) {
        [
          double(
            name: 'Joker escape',
            uid: 'gcpd_1002829',
            officer_email: 'james@gcpd.com',
            officer_name: 'James Gordon',
            description: 'Joker just broke out of prison',
            important: false
          ),
          double(
            name: 'Joker escape',
            uid: 'gcpd_1002830',
            officer_email: 'james@gcpd.com',
            officer_name: 'James Gordon',
            description: 'Joker just broke out of prison',
            important: false
          ),
          double(
            name: 'Strange does something strange',
            uid: 'gcpd_1009199',
            officer_email: 'carlos@gcpd.com',
            officer_name: 'Carlos Alvarez',
            description: 'Hugo Strange suspected of strange experiments on sheeps',
            important: true
          )
        ]
      }

      expect { ImportGcpdCases.call }.to change { Case.count }.by(3)
      expect { ImportGcpdCases.call }.to change { Case.count }.by(0)

      expect(Case.find_by!(case_uid: 'gcpd_1002829')).to have_attributes(
        officer_email: 'james@gcpd.com',
        officer_name: 'James Gordon',
        description: 'Joker just broke out of prison',
        department_code: 'gcpd',
        important: false
      )
      expect(Case.find_by!(case_uid: 'gcpd_1002830')).to have_attributes(
        officer_email: 'james@gcpd.com',
        officer_name: 'James Gordon',
        description: 'Joker just broke out of prison',
        department_code: 'gcpd',
        important: false
      )
      expect(Case.find_by!(case_uid: 'gcpd_1009199')).to have_attributes(
        officer_email: 'carlos@gcpd.com',
        officer_name: 'Carlos Alvarez',
        description: 'Hugo Strange suspected of strange experiments on sheeps',
        department_code: 'gcpd',
        important: true
      )
    end

    it 'assigns heroes to all cases created favoring heroes with the least cases assigned' do
      hulk = create(:hero, name: 'Hulk')
      thor = create(:hero, name: 'Thor')
      black_panther = create(:hero, name: 'Black Panther')
      create(:hero_case, hero: hulk)
      create(:hero_case, hero: thor)

      allow(GcpdWrapper).to receive(:get_cases) {
        [
          double(
            name: 'Joker escape',
            uid: 'gcpd_1002829',
            officer_email: 'james@gcpd.com',
            officer_name: 'James Gordon',
            description: 'Joker just broke out of prison',
            important: false
          ),
          double(
            name: 'Strange does something strange',
            uid: 'gcpd_1009199',
            officer_email: 'carlos@gcpd.com',
            officer_name: 'Carlos Alvarez',
            description: 'Hugo Strange suspected of strange experiments on sheeps',
            important: true
          )
        ]
      }

      expect { ImportGcpdCases.call }.to change { HeroCase.count }.by(2)

      black_panther_case = Case.find_by!(case_uid: 'gcpd_1002829')
      expect(HeroCase.where(hero_id: black_panther.id, case_id: black_panther_case.id)).to exist
      hulk_case = Case.find_by!(case_uid: 'gcpd_1009199')
      expect(HeroCase.where(hero_id: hulk.id, case_id: hulk_case.id)).to exist
    end

    it 'sends notification to leading officer, whose given case is handled by given hero', type: :mailer do
      create(:hero, name: 'Iron Man')
      allow(GcpdWrapper).to receive(:get_cases) {
        [
          double(
            name: 'Joker escape',
            uid: 'gcpd_1002829',
            officer_email: 'james@gcpd.com',
            officer_name: 'James Gordon',
            description: 'Joker just broke out of prison',
            important: false
          )
        ]
      }

      perform_enqueued_jobs do
        expect { ImportGcpdCases.call }.to \
          change { ActionMailer::Base.deliveries.count }.
          from(0).to(1)
      end

      email_sent = ActionMailer::Base.deliveries.last
      expect(email_sent).to have_attributes(
        to: match_array(['james@gcpd.com']),
        subject: 'Your case is now handled by Iron Man',
        body: include('Hey James Gordon! Iron Man is now dealing with your case (Joker escape), so no worries, it will be closed soon ;)')
      )
    end
  end
end
