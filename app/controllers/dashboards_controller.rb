require 'csv'

class DashboardsController < ApplicationController

  def show
    authorize(:dashboard, :show?)
    @admins = User.where(admin: true)
    @non_admins = User.where(admin:false)
    @non_validated_coachs = User.where(coach: true).where(validated_coach: false)
    @coachs = User.where(coach: true).where(validated_coach: true)
    @locations = Location.all
    @partners = Partner.all
  end

  def analytics
    authorize(:dashboard, :analytics?)
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

  def export_number_of_users
    authorize(:dashboard, :export_number_of_users?)
    @users = params[:data]
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
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
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
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
end
