namespace :check_24h_before_lesson do
  desc "Cancel all lessons with less than 5 participant 24h before the date"
  task check: :environment do
    @lessons = Lesson.where("date >= ?", Time.now)
    @lessons_not_complete = []
    @lessons.each do |lesson|
      if lesson.bookings.count < 5
        @lessons_not_complete << lesson
      end
    end
    @lessons_not_complete.each do |lesson|
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
