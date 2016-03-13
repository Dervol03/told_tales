# Represents the general user of the application, independently from its later
# role in an adventure.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :rememberable, :trackable, :validatable

  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validate  :password_has_numbers, :password_has_special_chars, if: :password
  validates :name, uniqueness: true, presence: true



  private


  def password_has_numbers
    unless password.match(/\d/)
      errors.add(:password, 'must contain at least one number')
    end
  end


  def password_has_special_chars
    special_char_set = %w(
     ! § $ % & / \( \) { [ ] } = ? \\ * + ~ # . , - _ @ ; : " '
    )

    special_char_set.each do |special_char|
      return true if password.include?(special_char)
    end
    errors.add(:password, 'must contain at least one special character')
  end


end
