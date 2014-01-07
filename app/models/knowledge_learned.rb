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


  def self.get_exp_by_day(user, course, selected_date)

    exp = ExperienceLog.where(
      :user_id => user.id,
      :course     => course,
      :created_at => selected_date.beginning_of_day..selected_date.end_of_day
    )

    exp.map { |e| e.after_exp - e.before_exp }.inject(:+) || 0
  end



  module UserMethods
    def get_history_experience(net_id)
      today = Time.now.to_date
      
      day_4 = KnowledgeLearned.get_exp_by_day(self, net_id, today - 4.day)
      day_3 = KnowledgeLearned.get_exp_by_day(self, net_id, today - 3.day)
      day_2 = KnowledgeLearned.get_exp_by_day(self, net_id, today - 2.day)
      day_1 = KnowledgeLearned.get_exp_by_day(self, net_id, today - 1.day)
      day_0 = KnowledgeLearned.get_exp_by_day(self, net_id, today)

      [day_4, day_3, day_2, day_1, day_0]
    end
  end



end