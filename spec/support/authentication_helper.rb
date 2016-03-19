def sign_in_with_role(role = :admin)
  shall_be_admin = role.to_sym == :admin
  user = User.where(is_admin: shall_be_admin).first || Fabricate(role)
  sign_in user
end


def error_401_template
  'shared/errors/401'
end
