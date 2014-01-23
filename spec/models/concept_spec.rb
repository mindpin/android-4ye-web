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

  context "concepts" do
    before{
      @net_id = 'test1'
      @net = KnowledgeNetAdapter.find(@net_id)
      @node_adapter_31 = @net.find_node_adapter_by_id("node-31")
      @node_adapter_32 = @net.find_node_adapter_by_id("node-32")
      @node_adapter_33 = @net.find_node_adapter_by_id("node-33")

      @node_31_concept = FactoryGirl.create :concept, {
        :knowledge_node_id => @node_adapter_31.node.id,
        :knowledge_net_id => @net_id
      }
      @node_32_concept = FactoryGirl.create :concept, {
        :knowledge_node_id => @node_adapter_32.node.id,
        :knowledge_net_id => @net_id
      }
      @node_33_concept = FactoryGirl.create :concept, {
        :knowledge_node_id => @node_adapter_33.node.id,
        :knowledge_net_id => @net_id
      }
      @user = FactoryGirl.create :user
    }

    it {
      @user.learned_concepts(@net_id).should =~ []
      @user.can_learn_concepts(@net_id).should =~ [@node_31_concept]
      @user.locked_concepts(@net_id).should =~ [@node_32_concept, @node_33_concept]

      @node_adapter_31.do_learn(@user)
      @user.learned_concepts(@net_id).should =~ [@node_31_concept]
      @user.can_learn_concepts(@net_id).should =~ [@node_32_concept]
      @user.locked_concepts(@net_id).should =~ [@node_33_concept]

      @user.query_concepts(@net_id, true, true).should =~ [@node_31_concept]
      @user.query_concepts(@net_id, true, false).should =~ []
      @user.query_concepts(@net_id, false, true).should =~ [@node_32_concept]
      @user.query_concepts(@net_id, false, false).should =~ [@node_33_concept]
      @user.query_concepts(@net_id, nil, nil).should =~ [@node_32_concept, @node_31_concept, @node_33_concept]
      @user.query_concepts(@net_id, nil, true).should =~ [@node_32_concept, @node_31_concept]
      @user.query_concepts(@net_id, nil, false).should =~ [@node_33_concept]
      @user.query_concepts(@net_id, true, nil).should =~ [@node_31_concept]
      @user.query_concepts(@net_id, false, nil).should =~ [@node_32_concept, @node_33_concept]
    }
  end
end
