require "spec_helper"

describe Question do
  describe Question::KnowledgeNodeRandomQuestion do
    class DummyKnowledgeNode
      include Question::KnowledgeNodeRandomQuestion

      def node_id
        "node-4"
      end
    end

    let(:node) {DummyKnowledgeNode.new}
    let(:kid) {"node-4"}
    let(:choices) {["A", "B", "C", "D"]}
    4.times do |i|
      let(:"q#{i + 1}") do
        FactoryGirl.create :question,
                           :knowledge_node_id => node.node_id,
                           :content => "some content",
                           :kind => Question::SINGLE_CHOICE,
                           :choices => choices,
                           :answer => choices[rand 4]
      end
    end

    describe "#get_random_question(except_ids)" do
      let(:randq) {node.get_random_question([q2._id, q3._id])}

      specify {[q1, q4].should include randq}
    end
  end
end
