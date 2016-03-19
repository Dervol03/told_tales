class UsersController < ApplicationController
  skip_before_action :register_first_user,
                     only: [:create, :new],
                     unless: any_user_exists

  skip_before_action :update_password_if_temporary,
                     only: [:update_password, :password]

  before_action :set_user, only: [:show,
                                  :edit,
                                  :update,
                                  :destroy,
                                  :password,
                                  :update_password]
  before_action :verify_admin,
                if: any_user_exists,
                except: [:show, :password, :update_password]

  before_action :verify_on_current_user, only: [:password, :update_password]

  def index
    @users = User.all
  end


  def show
  end


  def new
    @user = User.new
    @user.is_admin = !any_user_exists?
  end


  def edit
  end


  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to(*distinguish_by_user_count(@user))
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    respond_to do |format|
      if @user.update_without_password(user_params)
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


  def password
  end


  def update_password
    if @user.update(password_params)
      sign_out @user
      sign_in @user
      redirect_to @user, notice: 'Password was successfully updated.'
    else
      render :password
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
    params.require(:user).permit(
      :name,
      :email,
      :is_admin,
      :temporary_password,
      :password,
      :password_confirmation
    )
  end


  def password_params
    params.require(:user)
          .permit(:password, :password_confirmation)
          .merge(temporary_password: nil)
  end


  # if this is the first user, it shall land on the welcome page. Otherwise
  # fallback to Rails' default behavior.
  def distinguish_by_user_count(user)
    if User.count == 1
      sign_in user
      [root_path]
    else
      [user, {notice: 'User was successfully created.'}]
    end
  end


end
