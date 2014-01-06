require "spec_helper"

describe Question do
  let(:node_id) {"node-4"}
  let(:net_id) {"javascript"}
  let(:choices) {["A", "B", "C", "D"]}
  4.times do |i|
    let(:"q#{i + 1}") do
      FactoryGirl.create :question,
                         :knowledge_net_id => net_id,
                         :knowledge_node_id => node_id,
                         :content => "some content",
                         :kind => Question::SINGLE_CHOICE,
                         :choices => choices,
                         :answer => choices[rand 4]
    end
  end

  describe "::random_question_for_node_id(node_id)" do
    let(:randq) {Question.random_question_for_node_id(net_id, node_id)}
    specify {[q1, q2, q3, q4].should include randq}
  end

  describe "::random_questions_for_node_id(node_id, num)" do
    let(:randqs) {Question.random_questions_for_node_id(net_id, node_id, 4)}
    specify {[q1, q2, q3, q4].should_not eq randqs}
    specify {[q1, q2, q3, q4].should eq randqs.sort_by{|q| q.created_at}}
    specify {[q1, q2, q3, q4].should include(*randqs)}
  end
end
