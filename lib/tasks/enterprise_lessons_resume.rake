namespace :enterprise_lessons_resume do
  desc "Every sunday, send to employees a mail with a resume of their enterprise lessons this weekend"
  task resume: :environment do
    today = Date.today.strftime("%A").downcase
    next unless today == 'sunday'

    enterprises = User.where(status: :enterprise)
    unless enterprises.empty?
      enterprises.each do |enterprise|
        employees = enterprise.employees
        unless employees.empty?
          next_week_lessons = enterprise.enterprise_next_week_lessons
          employees.each do |employee|
            mail = LessonMailer.with(lessons: next_week_lessons, user: employee).enterprise_lessons_resume
            mail.deliver_now
          end
        end
      end
    end
  end
end
