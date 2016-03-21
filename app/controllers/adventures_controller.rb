class AdventuresController < ApplicationController
  before_action :verify_player, only: [:play, :next_event]

  # GET /adventures
  # GET /adventures.json
  def index
    @adventures = Adventure.all
  end


  # GET /adventures/1
  # GET /adventures/1.json
  def show
    adventure
  end


  # GET /adventures/new
  def new
    @adventure = Adventure.new(owner_id: current_user.id)
  end


  # GET /adventures/1/edit
  def edit
    adventure
  end


  # POST /adventures
  # POST /adventures.json
  def create
    @adventure = Adventure.new(adventure_params)

    if @adventure.save
      redirect_to @adventure, notice: 'Adventure was successfully created.'
    else
      render :new
    end
  end


  # PATCH/PUT /adventures/1
  # PATCH/PUT /adventures/1.json
  def update
    if adventure.update(adventure_params)
      redirect_to @adventure, notice: 'Adventure was successfully updated.'
    else
      render :edit
    end
  end


  # DELETE /adventures/1
  # DELETE /adventures/1.json
  def destroy
    if adventure.destroy_as(current_user)
      redirect_to(adventures_url,
                  notice: 'Adventure was successfully destroyed.')
    else
      redirect_to :back
    end
  end


  # Adds the current user to an adventure in the desired role.
  def join
    msg = if adventure.seat_available?(join_role)
            join_adventure(join_role)
          else
            "role #{join_role} has already been taken"
          end

    redirect_to adventures_url, notice: msg
  end


  # Starts the play environment of the adventure.
  def play
    if adventure.start
      @last_events = adventure.last_events(2)
      @current_event = adventure.current_event
    else
      redirect_to adventures_url, notice: 'Adventure is not ready yet!'
    end
  end


  # Sets up the next event of the adventure.
  def next_event
    adventure.next_event

    redirect_to play_adventure_url(adventure)
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def adventure
    @adventure ||= Adventure.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def adventure_params
    raw = params.require(:adventure).permit(:name, :setting, :owner_id)
    raw[:owner] = User.find(raw[:owner_id]) unless raw[:owner_id].blank?
    raw
  end


  def join_role
    params.require(:role).to_sym
  end


  def join_adventure(role)
    if @adventure.update(role => current_user)
      "you were assigned role #{join_role}"
    else
      @adventure.errors.full_messages.join("\n")
    end
  end


  def verify_player
    render_401 unless adventure.role_of_user(current_user) == :player
  end


end
