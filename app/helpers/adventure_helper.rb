# Some helpers for Aventure views
module AdventureHelper
  # Expands a link to join an adventure
  def join_adventure_link(adventure, role)
    link_to "Join as #{role.capitalize}",
            join_adventure_path(id: adventure.to_param, role: role),
            method: :put
  end
end
