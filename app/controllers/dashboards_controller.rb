class DashboardsController < ApplicationController

  def show
    authorize(:dashboard, :show?)
    @admins = User.where(admin: true)
    @non_admins = User.where(admin:false)
    @non_validated_coachs = User.where(coach: true).where(validated_coach: false)
    @coachs = User.where(coach: true).where(validated_coach: true)
    @locations = Location.all.order(id: :asc)
    @partners = Partner.all.order(id: :asc)
    @promo_codes = PromoCode.all.order(id: :asc)
  end

  def analytics
    authorize(:dashboard, :analytics?)

    @reasons_many_mails = Reason.where(title: helpers.many_mails).count
    @reasons_not_relevant = Reason.where(title: helpers.not_relevant).count
    @reasons_not_interested = Reason.where(title: helpers.not_interested).count
    @reasons_stop_receive_mails = Reason.where(title: helpers.stop_receive_mails).count
    @reasons_others = Reason.where(title: helpers.others).count
    @reasons_others_text = Reason.where(title: helpers.others).map { |reason| reason.other_text }

    @users = User.where(coach: false).group_by_month.count
    @coachs = User.where(coach: true).group_by_month.count
    @bookings = Booking.where(status: "effectuée").where(used_credit: false).group_by{ |u| u.lesson.date.beginning_of_month }
    @bookings_credit = Booking.where(status: "effectuée").where(used_credit: true).group_by{ |u| u.lesson.date.beginning_of_month }
     # la moyenne du taux de remplissage des séances de sport par mois
    if Lesson.all.any?
      first_lesson_date = Lesson.all.pluck(:date).min
      first_day = first_lesson_date.beginning_of_month
      last_day = first_lesson_date.end_of_month
      @lessons_filling_rate = []

      if first_day <= Date.today
        until last_day.strftime("%m%Y") == Date.today.next_month.strftime("%m%Y") do
          filling_rate = 0
          lessons_in_month = Lesson.all.where('date >= ? AND date <= ?', first_day, last_day)
          if lessons_in_month.count == 0
            month = l(first_day, format: '%B %Y').capitalize
            @lessons_filling_rate << {month: month, average_filling_rate: 0}
          else
            lessons_in_month.each do |lesson|
              unless lesson.bookings.count == 0
                filling_rate += (lesson.bookings.count / 10.to_f)
              end
            end
            average_filling_rate = filling_rate / lessons_in_month.count
            month = l(first_day, format: '%B %Y').capitalize
            @lessons_filling_rate << {month: month, average_filling_rate: average_filling_rate}
          end
          first_day = first_day.next_month
          last_day = first_day.end_of_month
        end
      end
    else
      @lessons_filling_rate = []
      @lessons_filling_rate << {month: l(Date.today, format: '%B %Y').capitalize, average_filling_rate: 0}
    end
  end

  def all_lessons
    authorize(:dashboard, :all_lessons?)
    @lessons = Lesson.where("date >= ?", Time.now).order('date DESC')
  end
end
