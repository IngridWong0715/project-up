class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users

  has_many :projects
  has_many :tasks, through: :projects


  validates :name, presence: true

  def self.has_fewer_than(number)

  end

end
