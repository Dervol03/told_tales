class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.all
  end


  def show
  end


  def new
    @user = User.new
  end


  def edit
  end


  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html do
          redirect_to @user, notice: 'User was successfully created.'
        end
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        # format.json do
        #   render json: @user.errors, status: :unprocessable_entity
        # end
      end
    end
  end


  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to @user, notice: 'User was successfully updated.'
        end
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        # format.json do
        #   render json: @user.errors, status: :unprocessable_entity
        # end
      end
    end
  end


  def destroy
    @user.destroy
    respond_to do |format|
      format.html do
        redirect_to users_url, notice: 'User was successfully destroyed.'
      end
      # format.json { head :no_content }
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def user_params
    params.require(:user).permit(:name,
                                 :password,
                                 :email,
                                 :password_confirmation)
  end
end
