class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_one :subscription
  has_many :bookings
  has_many :lessons
  has_many :friend_requests_as_requestor, foreign_key: :requestor_id, class_name: :FriendRequest
  has_many :friend_requests_as_receiver, foreign_key: :receiver_id, class_name: :FriendRequest
  has_many :friendships_as_friend_a,
      foreign_key: :friend_a_id,
      class_name: :Friendship
  has_many :friendships_as_friend_b,
     foreign_key: :friend_b_id,
     class_name: :Friendship
  has_many :friend_as, through: :friendships_as_friend_b
  has_many :friend_bs, through: :friendships_as_friend_a
  has_many :subjects
  has_many :answers
  has_many :pack_orders
  has_many :reasons
  has_many :user_codes
  has_many :promo_codes, through: :user_codes

  enum gender: { homme: 0, femme: 1, autres: 2 }
  enum sport_habits: { rarely: 0, occasionnally: 1, regularly: 2 }
  enum physical_pain: { oui: 0, non: 1 }
  enum level: { inexperimente: 0, occasionnel: 1, regulier: 2, inconditionnel: 3, athlete: 4 }
  enum intensity: { intense: 0, endurance: 1, fun: 2, learn: 3 }
  enum expectations: { relax: 0, letgo: 1, amuse: 2, weight_loss: 3, muscle: 4, healthy: 5 }
  enum company_discover: { internet: 0, your_company: 1, social_networks: 2, word_of_mouth: 3, other: 4 }
  enum status: { person: 0, enterprise: 1 }

  validates :email, uniqueness: true, presence: true
  validates :gender, inclusion: { in: genders.keys }, allow_nil: true
  validates :sport_habits, inclusion: { in: sport_habits.keys }, allow_nil: true
  validates :physical_pain, inclusion: { in: physical_pains.keys }, allow_nil: true
  validates :level, inclusion: { in: levels.keys }, allow_nil: true
  validates :intensity, inclusion: { in: intensities.keys }, allow_nil: true
  validates :expectations, inclusion: { in: expectations.keys }, allow_nil: true
  validates :company_discover, inclusion: { in: company_discovers.keys }, allow_nil: true
  validates :status, inclusion: { in: statuses.keys }, presence: true
  validates :first_name, presence: true, if: -> { person? }
  validates :last_name, presence: true, if: -> { person? }
  validates :optin_cgv, presence: true
  validates :enterprise_name, presence: true, if: -> { enterprise? }
  validates :phone_number, presence: true, if: -> { enterprise? }

  scope :group_by_month, -> { group("date_trunc('month', created_at) ") }
  scope :no_admins, -> { where(admin: false) }

  before_save :remove_empty_spaces
  after_create :find_waiting_bookings, :create_empty_sub, :send_welcome_mail, :set_enterprise_code

  def friendships
    self.friendships_as_friend_a + self.friendships_as_friend_b
  end

  def my_friends
    @my_friendships = self.friendships
    @my_friends = []
    @my_friendships.each do |friendship|
      @my_friends << User.find(friendship.friend_a_id)
      @my_friends << User.find(friendship.friend_b_id)
      @my_friends = @my_friends.uniq
      @my_friends.delete(self)
    end
    @my_friends
  end

  def profile_picture
    if avatar.attached?
      avatar.key
    else
      "avatar/avatar-default"
    end
  end

  def full_name
    "#{first_name.capitalize} #{last_name.upcase}"
  end

  def find_age
    return if birth_date.blank?

    now = Time.now.utc.to_date
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end

  def has_credit(lesson_date)
    subscription = self.subscription
    bookings_count = 0
    if subscription.active?
      lessons_included = subscription.nickname.first(2).to_i
      first_day_of_month = lesson_date.beginning_of_month
      last_day_of_month = lesson_date.end_of_month
      self.bookings.where(status: 'confirmé').each do |b|
        if b.lesson.date.to_date >= first_day_of_month && b.lesson.date.to_date <= last_day_of_month
          bookings_count += 1
        end
      end
      return { has_credit: true, origin: "subscription" } if bookings_count < lessons_included
    end

    if self.credit_count > 0
      self.update(credit_count: credit_count - 1)
      return { has_credit: true, origin: "credit" }
    end

    { has_credit: false, origin: "" }
  end

  def coupon
    domain_to_check = email.split("@").last
    partners_domains = Partner.all.pluck(:domain_name)
    if partners_domains.include?(domain_to_check)
      partner = Partner.find_by(domain_name: domain_to_check)
      return { exist: true, code: partner.coupon_code, percentage: partner.percentage }
    end
    { exist: false, code: nil, percentage: nil }
  end

  private

  def create_empty_sub
    s = Subscription.new
    s.user = self
    s.save
  end

  def send_welcome_mail
    if person? && !admin? && !coach?
      mail = UserMailer.with(user: self).welcome_mail
    elsif enterprise?
      mail = UserMailer.with(user: self).welcome_mail_enterprise
    end
    mail.deliver_now
  end

  def remove_empty_spaces
    self.email = self.email.gsub(/\s+/, '').downcase
    self.first_name = self.first_name.gsub(/\s+/, '')
    self.last_name = self.last_name.gsub(/\s+/, '')
  end

  def find_waiting_bookings
    waiting_bookings = WaitingBooking.where(user_email: email)
    return if waiting_bookings.empty?

    waiting_bookings.each do |waiting_booking|
      Booking.create(user: self, lesson: waiting_booking.lesson, status: "Invitation envoyée")
      waiting_booking.destroy
    end
    self.update(promo_code_used: true, credit_count: 1)
  end

  def set_enterprise_code
    return unless enterprise? && enterprise_code.blank?

    new_enterprise_code = [*('a'..'z'), *('0'..'9')].sample(10).join.upcase
    while User.find_by(enterprise_code: new_enterprise_code).present?
      new_enterprise_code = [*('a'..'z'), *('0'..'9')].sample(10).join.upcase
    end
    self.update(enterprise_code: new_enterprise_code)
  end
end
