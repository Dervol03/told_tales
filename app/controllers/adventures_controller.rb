class AdventuresController < ApplicationController
  # GET /adventures
  # GET /adventures.json
  def index
    load_adventures
  end

  # GET /adventures/1
  # GET /adventures/1.json
  def show
    load_adventure
  end

  # GET /adventures/new
  def new
    @adventure = Adventure.new(owner_id: current_user.id)
  end

  # GET /adventures/1/edit
  def edit
    load_adventure
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
    load_adventure

    if @adventure.update(adventure_params)
      redirect_to @adventure, notice: 'Adventure was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /adventures/1
  # DELETE /adventures/1.json
  def destroy
    load_adventure
    if @adventure.destroy_as(current_user)
      redirect_to(adventures_url,
                  notice: 'Adventure was successfully destroyed.')
    else
      redirect_to :back
    end
  end


  # Adds the current user to an adventure in the desired role.
  def join
    load_adventure
    msg = if role_available?(join_role)
            join_adventure(join_role)
          else
            "role #{join_role} has already been taken"
          end

    load_adventures
    redirect_to :back, notice: msg
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def load_adventure
    @adventure = Adventure.find(params[:id])
  end


  def load_adventures
    @adventures = admin? ? Adventure.all : Adventure.pending(current_user)
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


  def role_available?(role)
    @adventure.vacant_seats.include?(role)
  end


  def join_adventure(role)
    if @adventure.update(role => current_user)
      "you were assigned role #{join_role}"
    else
      @adventure.errors.full_messages.join("\n")
    end
  end
end
