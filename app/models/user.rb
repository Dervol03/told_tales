# Represents the general user of the application, independently from its later
# role in an adventure.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :rememberable, :trackable, :validatable

  validates :password, confirmation: true
  validates :password_confirmation, presence: true



end
