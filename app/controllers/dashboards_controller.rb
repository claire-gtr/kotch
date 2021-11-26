require 'csv'

class DashboardsController < ApplicationController
  def show
    authorize(:dashboard, :show?)
    @admins = User.where(admin: true)
    @non_admins = User.where(admin:false)
    @non_validated_coachs = User.where(coach: true).where(validated_coach: false)
    @coachs = User.where(coach: true).where(validated_coach: true)
    @locations = Location.where(visible: true).order(id: :asc)
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

    @company_discover_internet = User.where(company_discover: :internet).count
    @company_discover_your_company = User.where(company_discover: :your_company).count
    @company_discover_social_networks = User.where(company_discover: :social_networks).count
    @company_discover_word_of_mouth = User.where(company_discover: :word_of_mouth).count
    @company_discover_other = User.where(company_discover: :other).count
    @company_discovers = {
      internet: @company_discover_internet,
      your_company: @company_discover_your_company,
      social_networks: @company_discover_social_networks,
      word_of_mouth: @company_discover_word_of_mouth,
      other: @company_discover_other
    }

    @lessons_done_this_year = Lesson.includes([:location, :user]).where(status: "effectuée").where('extract(year from date) = ?', Date.today.year).order('date DESC')
    if @lessons_done_this_year.any?
      @lessons_done_this_year_hash = []
      @lessons_done_this_year.each do |lesson|
        @lessons_done_this_year_hash << { date: lesson.date, location: lesson.location.name, sport_type: lesson.sport_type, coach_name: lesson.user.full_name, bookings: lesson.bookings.count, lesson_id: lesson.id, status: lesson.status, public: lesson.public, focus: lesson.focus }
      end
    end

    @users = User.where(coach: false).group_by_month.count
    @coachs = User.where(coach: true).group_by_month.count
    @bookings = Booking.includes([:lesson]).by_lesson_status("effectuée").where(used_credit: false).group_by{ |u| u.lesson.date.beginning_of_month }
    @bookings_credit = Booking.includes([:lesson]).by_lesson_status("effectuée").where(used_credit: true).group_by{ |u| u.lesson.date.beginning_of_month }
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
      @lessons_filling_rate << { month: l(Date.today, format: '%B %Y').capitalize, average_filling_rate: 0 }
    end
  end

  def export_number_of_users
    authorize(:dashboard, :export_number_of_users?)
    @users = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'abonnes.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @users.keys.map { |date| l(date.to_date, format: '%B %Y').capitalize}
      csv << @users.values
    end
    send_file(
      "#{Rails.root}/abonnes.csv",
      filename: "abonnes.csv",
      type: "application/csv"
    )
  end

  def export_number_of_coachs
    authorize(:dashboard, :export_number_of_coachs?)
    @coachs = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'coachs.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @coachs.keys.map { |date| l(date.to_date, format: '%B %Y').capitalize}
      csv << @coachs.values
    end
    send_file(
      "#{Rails.root}/coachs.csv",
      filename: "coachs.csv",
      type: "application/csv"
    )
  end

  def all_lessons
    authorize(:dashboard, :all_lessons?)
    @lessons = Lesson.includes([:location, :bookings, :users, :user]).where("date >= ?", Time.now).order('date ASC')
  end

  def export_lessons_sub
    authorize(:dashboard, :export_lessons_sub?)
    @bookings = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'lessons_with_subscriptions.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @bookings.keys.map { |date| l(date.to_date, format: '%B %Y').capitalize}
      csv << @bookings.values.map { |value| value.size }
    end
    send_file(
      "#{Rails.root}/lessons_with_subscriptions.csv",
      filename: "lessons_with_subscriptions.csv",
      type: "application/csv"
    )
  end

  def export_lessons_credit
    authorize(:dashboard, :export_lessons_credit?)
    @bookings_credit = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'lessons_with_credit.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @bookings_credit.keys.map { |date| l(date.to_date, format: '%B %Y').capitalize}
      csv << @bookings_credit.values.map { |value| value.size }
    end
    send_file(
      "#{Rails.root}/lessons_with_credit.csv",
      filename: "lessons_with_credit.csv",
      type: "application/csv"
    )
  end

  def export_filling_rate
    authorize(:dashboard, :export_filling_rate?)
    @lessons_filling_rate = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'lessons_filling_rate.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @lessons_filling_rate.map { |hash| hash["month"]}
      csv << @lessons_filling_rate.map { |hash| hash["average_filling_rate"]}
    end
    send_file(
      "#{Rails.root}/lessons_filling_rate.csv",
      filename: "lessons_filling_rate.csv",
      type: "application/csv"
    )
  end

  def export_lessons_done_this_year
    authorize(:dashboard, :export_lessons_done_this_year?)
    @lessons_done_this_year = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'lessons_done_this_year.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @lessons_done_this_year.map { |hash| hash["date"] }
      csv << @lessons_done_this_year.map { |hash| hash["location"] }
      csv << @lessons_done_this_year.map { |hash| hash["sport_type"] }
      csv << @lessons_done_this_year.map { |hash| hash["coach_name"] }
      csv << @lessons_done_this_year.map { |hash| hash["bookings"] }
      # csv << @lessons_done_this_year.map { |hash| hash["lesson_id"]}
      # csv << @lessons_done_this_year.map { |hash| hash["status"]}
      # csv << @lessons_done_this_year.map { |hash| hash["public"]}
      # csv << @lessons_done_this_year.map { |hash| hash["focus"]}
    end
    send_file(
      "#{Rails.root}/lessons_done_this_year.csv",
      filename: "lessons_done_this_year.csv",
      type: "application/csv"
    )
  end

  def export_company_discovers
    authorize(:dashboard, :export_company_discovers?)
    @company_discovers = params[:data]
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath    = 'company_discovers.csv'

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << @company_discovers.keys
      csv << @company_discovers.values
    end
    send_file(
      "#{Rails.root}/company_discovers.csv",
      filename: "company_discovers.csv",
      type: "application/csv"
    )
  end

  def export_users_data
    authorize(:dashboard, :export_users_data?)
    @no_admin_users = User.no_admins.order(id: :asc)
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"' }
    filepath = 'users_data.csv'
    headers = ['genre', 'nom', 'prénom', 'âge', 'email', 'portable', 'nombre de séances réalisées', 'abonné ?', 'coach ?', 'newsletter ?']

    csv_file = CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << headers
      @no_admin_users.each do |user|
        csv << {
          gender: user.gender,
          last_name: user.last_name,
          first_name: user.first_name,
          age: user.find_age,
          email: user.email,
          phone_number: user.phone_number,
          bookings: user.coach? ? user.lessons.reject { |lesson| lesson.status != 'effectuée' }.size : user.bookings.reject { |booking| booking.lesson.status != 'effectuée' }.size,
          subscription: user.subscription&.status == 'active' ? 'oui' : 'non',
          coach: user.coach? ? 'oui' : 'non',
          terms: user.terms? ? 'oui' : 'non'
        }.values
      end
    end
    send_file(
      "#{Rails.root}/users_data.csv",
      filename: "users_data.csv",
      type: "application/csv"
    )
  end
end
