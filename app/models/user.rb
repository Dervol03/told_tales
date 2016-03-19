# Represents the general user of the application, independently from its later
# role in an adventure.
class User < ActiveRecord::Base
  # Email Regexp from Devise
  EMAIL_FORMAT = /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable

  has_many :adventures,
           inverse_of: :owner,
           foreign_key: :owner_id

  has_many :played_adventures,
           class_name: 'Adventure',
           inverse_of: :player,
           foreign_key: :player_id

  has_many :mastered_adventures,
           class_name: 'Adventure',
           inverse_of: :master,
           foreign_key: :master_id

  with_options unless: :temporary_password? do
    validates :password,
              presence:     {if: :password_required?},
              confirmation: {if: :password_required?},
              length:       {within: 6..72, allow_blank: true}

    validate  :password_has_numbers,
              :password_has_special_chars, if: :password
  end

  # Email validation copied from devise
  validates :email,
            presence: true,
            uniqueness: { allow_blank: true, if: :email_changed? },
            format: {
              with:        EMAIL_FORMAT,
              allow_blank: true,
              if:          :email_changed?
            }


  validates :name, uniqueness: true, presence: true

  after_validation :equalize_passwords, if: :temporary_password?

  before_destroy :last_admin_must_survive



  private


  def password_has_numbers
    unless password =~ /\d/
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


  def last_admin_must_survive
    if is_admin? && self.class.where(is_admin: true).count == 1
      errors.add(:base, 'at least one admin must exist')
      return false
    end
  end


  # Checks whether a password is needed or not. For validations only.
  # Passwords are always required if it's a new record, or if the password
  # or confirmation are being set somewhere.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end


  def equalize_passwords
    self.password = temporary_password
  end
end
