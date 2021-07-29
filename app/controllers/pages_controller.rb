class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def faq
  end

  def forum
    @subjects = Subject.all
  end
end
