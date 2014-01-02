require "spec_helper.rb"

describe KnowledgeLearned do
  before{
    @net = KnowledgeNet.get_by_name("test1")
  }


  # 1 初始情况下的解锁和学习状态
  # 2 初始情况下学习第一个单元的第一个节点
  # 3 初始情况下学习第一个单元下的所有节点
  # 4 初始情况下学习第一个检查点包括的所有单元下的节点
  # 5 初始情况下学习第一个检查点
end