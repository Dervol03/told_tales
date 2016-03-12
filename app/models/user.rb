# Represents the general user of the application, independently from its later
# role in an adventure.
class User < ActiveRecord::Base
  # Override default password length of devise's validation
  Devise.password_length = 6..75

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable



end
