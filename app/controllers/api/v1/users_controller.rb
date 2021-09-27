class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :cognito_authorized, only: [:index]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    new_params = {
      username: params[:username],
      password: params[:password],
      fullname: params[:fullname],
      email: params[:email],
      photo: params[:photo],
     }

     cognito_signup(new_params)

    # @user = User.new(new_params)

    # if @user.save
    #   render json: @user, status: :created
    # else
    #   render json: @user.errors, status: :unprocessable_entity
    # end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {}).permit!
    end

    def cognito_create_user(params)
      # params.each{ | item| puts item }

      cognito = get_cognito()
      cognito.admin_create_user({
        user_pool_id: ENV["COGNITO_POOL_ID"],
        username: params[:username],
        user_attributes: [
          {name: "email", value: params[:email]},
          # {name: "password_digest", value: params[:password_digest]},
          # {name: "bot_mode", value: params[:modo_bot]},
          {name: "name", value: params[:fullname]},
        ],
        temporary_password: "1234567"
      })
    end

    def cognito_signup(params)
      username = params[:username]
      options = {
        client_id: ENV["COGNITO_CLIENT_ID"], # required
        secret_hash: get_hash_secret(username),
        username: username, # required
        password: params[:password], # required
        user_attributes: [
          {
            name: "email", # required
            value: params[:email],
          },
          {
            name: "name", # required
            value: params[:fullname],
          },
        ],
        
      }

      cognito = get_cognito()
      res = cognito.sign_up(options)
    end
end
