class KnowledgeLearned
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     :type => Integer
  field :model_type,  :type => String
  field :model_id,    :type => String
  field :course,      :type => String

  validates :model_id, :uniqueness => {
    :scope => [:user_id, :model_type, :course]
  }

  def self.create_by_params(params)
    KnowledgeLearned.create(
      :user_id  => params[:user].id,
      :model_id => params[:model].id,
      :model_type => params[:model].class.name,
      :course => params[:model].net.name
    )
  end

  def self.is_learned?(model, user)
    KnowledgeLearned.where(
      :course     => model.net.name,
      :model_id   => model.id,
      :model_type => model.class.name,
      :user_id    => user.id
    ).exists?
  end



  module UserMethods
    def get_history_experience(net_id)
      today = Time.now.to_date

      day_4 = ExperienceLog.get_by_day(self, net_id, today - 4.day)
      day_3 = ExperienceLog.get_by_day(self, net_id, today - 3.day)
      day_2 = ExperienceLog.get_by_day(self, net_id, today - 2.day)
      day_1 = ExperienceLog.get_by_day(self, net_id, today - 1.day)
      day_0 = ExperienceLog.get_by_day(self, net_id, today)

      [day_4, day_3, day_2, day_1, day_0]
    end
  end



end