class SubjectsController < ApplicationController

  def create
    @subject = Subject.new(subject_params)
    @subject.user = current_user
    authorize @subject
    if @subject.save
      redirect_to subject_path(@subject)
    else
      @subject = Subject.new
      render 'pages/forum'
    end
  end

  def new
    @subject = Subject.new
    authorize @subject
  end

  def show
    @subject = Subject.find(params[:id])
    authorize @subject
    @answer = Answer.new
  end

  private

  def subject_params
    params.require(:subject).permit(:title, :content)
  end
end
