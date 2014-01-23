class Api::ConceptsController < ApplicationController
  def learned_node_random_questions
    concept = Concept.find(params[:id])
    count = params[:count] ? params[:count].to_i : 1
    questions = current_user.learned_node_random_questions_for_concept(concept, count)
    render :json => questions.map(&:as_json)
  end
end
