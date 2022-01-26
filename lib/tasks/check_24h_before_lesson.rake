namespace :check_24h_before_lesson do
  desc "Cancel all lessons with less than 5 participant 24h before the date"
  task check: :environment do
    @lessons = Lesson.where("date >= ?", Time.now)
    @lessons_not_complete = []
    @lessons.each do |lesson|
      if lesson.bookings.count < 5 && !lesson.status = "Pre-validée"
        @lessons_not_complete << lesson
      end
    end
    @lessons_without_coach = @lessons.where(user: nil)
    @lessons_to_be_checked = @lessons_without_coach + @lessons_not_complete
    @lessons_to_be_checked.each do |lesson|
      next if lesson.enterprise?

      if lesson.diff_time < DateTime.now
        lesson.status = "canceled"
        lesson.save
        lesson.bookings.each do |booking|
          booking.status = "canceled"
          booking.save
          booking.user.update(credit_count: booking.user.credit_count + 1) if booking.used_credit
        end
      end
    end
  end
end
