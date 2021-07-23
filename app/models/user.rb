class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  enum gender: { homme: 0, femme: 1, autres: 2 }
  enum sport_habits: { regularly: 0, occasionnally: 1, rarely: 2 }
  enum physical_pain: { pain_regular: 0, pain_occasionnal: 1, pain_rare: 2 }
  enum level: { inexperimente: 0, occasionnel: 1, regulier: 2, inconditionnel:3, athlete: 4 }
  enum intensity: { intense: 0, endurance: 1, fun: 2, learn: 3 }
  enum expectations: { relax: 0, letgo: 1, unstress: 2, muscle: 3, tonification: 4, weight_loss: 5, healthy: 6}
  validates :gender, inclusion: { in: genders.keys }, allow_nil: true
  validates :sport_habits, inclusion: { in: sport_habits.keys }, allow_nil: true
  validates :physical_pain, inclusion: { in: physical_pains.keys }, allow_nil: true
  validates :level, inclusion: { in: levels.keys }, allow_nil: true
  validates :intensity, inclusion: { in: intensities.keys }, allow_nil: true
  validates :expectations, inclusion: { in: expectations.keys }, allow_nil: true


   def profile_picture
    if avatar.attached?
      avatar.key
    else
      "avatar/avatar-default"
    end
  end
end
