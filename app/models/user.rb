class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  enum gender: { homme: 0, femme: 1, autres: 2 }
  validates :gender, inclusion: { in: genders.keys }

   def profile_picture
    if avatar.attached?
      avatar.key
    end
    # else
    #   avatar.key# "avatar/avatar_default"
    # end
  end
end
