class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect
  # before the location can be stored.
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :messages_not_readed
  before_action :friend_request_received

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "Vous ne pouvez pas faire cette action."
    redirect_to(root_path)
  end

  def average_rating
    sum = 0
    count = 0
    if self.reviews.any?
      self.reviews.each do |review|
        sum =+ review.rating
        count =+ 1
      end
      return sum/count
    else
      return 0
    end
  end

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :avatar, :address, :phone_number, :birth_date, :gender, :sport_habits, :level, :intensity, :expectations, :physical_pain, :coach, :terms, :optin_cgv])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :avatar, :address, :phone_number, :birth_date, :gender, :sport_habits, :level, :intensity, :expectations, :physical_pain, :terms])
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  private

  def friend_request_received
    if current_user && !current_user.coach?
      @new_friend_requests_received = FriendRequest.where(receiver: current_user, status: "pending").first
    end
  end

  def messages_not_readed
    if current_user && current_user.coach?
      @message_not_readed_coach = current_user.lessons&.map { |lesson| lesson.messages }.flatten.select { |message| message.readed == false }.first
    elsif current_user
      @message_not_readed_customer = current_user.bookings&.find_by(messages_readed: false)
    end
  end

  def a_valid_email?(email)
    email =~ /\A[^@\s]+@[^@\s]+\z/
  end

  # Its important that the location is NOT stored if:
  # - The request method is not GET (non idempotent)
  # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an
  #    infinite redirect loop.
  # - The request is an Ajax request as this can lead to very unexpected behaviour.
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
