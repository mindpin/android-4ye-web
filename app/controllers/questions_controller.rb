class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
  end

  def edit
    @question = Question.find(params[:id])
    @yaml = @question ? @question.to_yaml.split("\n")[1..-1].join("\n") : ""
  end

  def create
    @question = Question.from_yaml(params[:yaml])
    @question.save
    redirect_to :action => :index
  end

  def update
    hash = YAML.load(params[:yaml])
    @question = Question.find(params[:id])
    @question.update_attributes hash
    redirect_to :back
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy if @question
    redirect_to :action => :index
  end
end
