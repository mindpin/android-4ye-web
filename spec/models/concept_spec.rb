require "spec_helper.rb"

describe Concept do
  context "class methods" do
    describe "::concept_from(node_ids)" do
      let(:net_id)   {"javascript"}
      let(:node_ids) {%w{node-1 node-2}}
      let(:result)   {Concept.concepts_from(net_id, node_ids + ["node-3"])}
      before(:each) do
        node_ids.reduce(4) do |acc, node_id|
          acc.times do
            FactoryGirl.create :concept, {
              :name => "#{node_id} concept #{rand}",
              :desc => "",
              :knowledge_node_id => node_id,
              :knowledge_net_id => net_id
            }
          end
          3
        end
      end

      specify {result.count.should be 7}
    end
  end
end
