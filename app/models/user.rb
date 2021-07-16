class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
   has_one_attached :avatar

   def profile_picture
    if avatar.attached?
      avatar.key
    end
    # else
    #   avatar.key# "avatar/avatar_default"
    # end
  end
end
