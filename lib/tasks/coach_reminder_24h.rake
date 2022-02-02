namespace :coach_reminder_24h do
  desc "Every day, send to coachs a mail with a resume of their today lessons"
  task resume: :environment do
    validated_coachs = User.validated_coachs
    unless validated_coachs.empty?
      validated_coachs.each do |coach|
        lessons_next_24h = coach.coach_lessons_next_24h
        mail = LessonMailer.with(lessons: lessons_next_24h, user: coach).coach_next_24h
        mail.deliver_now
      end
    end
  end
end
