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

end