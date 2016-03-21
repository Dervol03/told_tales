# Some helpers for Aventure views
module AdventureHelper
  # Expands a link to join an adventure
  def join_adventure_links(adventure)
    return nil unless adventure.role_of_user(current_user).nil?

    links = adventure.vacant_seats.map do |role|
      link_to "As #{role.capitalize}",
              join_adventure_path(id: adventure.to_param, role: role),
              method: :put
    end

    links.join(' ').html_safe
  end

  # Generates a link to the play area of an adventure. Depending on whether
  # the logged in user is a player or the master of the adventure, she will
  # get a link to a different area.
  def play_adventure_link(adventure)
    user_role = adventure.role_of_user(current_user)
    return nil if user_role.blank?

    target = send("#{user_role}_target", adventure)
    link_to 'Play', target
  end


  private

  def player_target(adventure)
    play_adventure_url(adventure)
  end


  def master_target(adventure)
    adventure_events_url(adventure)
  end


end
