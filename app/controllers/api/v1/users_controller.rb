class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorized, only: [:index]

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
    puts params
    puts

    @user = User.new({
       username: params[:username],
       password: params[:password]
      })

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
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
      params.each{ | item| puts item }

      cognito = get_cognito()
      cognito.admin_create_user({
        user_pool_id: "us-east-1_uAuAWzwr6",
        username: "c4",
        user_attributes: [
            {name: "email", value: "c4@semi.dev"},
        ],
        temporary_password: "1234567"
      })
    end

end
