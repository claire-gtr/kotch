class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @subject = Subject.find(params[:subject_id])
    @answer.subject = @subject
    authorize @answer
    if @answer.save
      redirect_to subject_path(@subject)
    else
      @answer = Answer.new
      render 'subjects/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
