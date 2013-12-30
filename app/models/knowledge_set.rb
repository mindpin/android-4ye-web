class KnowledgeSet
  attr_accessor :set_id, :name, :icon, :deep

  def initialize(attrs)
    @set_id = attrs.delete :set_id
    @name   = attrs.delete :name
    @icon   = attrs.delete :icon
    @deep   = attrs.delete :deep
  end
end