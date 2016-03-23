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


  # Generates link label for the next event. If the next event is bound to a
  # choice not taken, it will take the description of this choice, providing the
  # possibility of inevitable choices. Otherwise, it will return 'Continue...'
  #
  # @param [Adventure] adventure for which to generate the link
  # @return [String] choice description or 'Continue...'
  #   style.
  def next_event_label(adventure)
    next_event = adventure.current_event.next_event
    next_event.choice.present? ? next_event.choice.decision : 'Continue...'
  end


  private

  def player_target(adventure)
    play_adventure_url(adventure)
  end


  def master_target(adventure)
    adventure_events_url(adventure)
  end


end
