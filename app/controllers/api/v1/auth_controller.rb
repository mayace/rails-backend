class Api::V1::AuthController < ApplicationController
    
    def hola
        render json: {message: "Hola mundo"}
    end

    def login
        ActionCable.server.broadcast("some_channel", "login");
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: { :user=> @user.as_json(except: [:password_digest]), access_token: token}
        else
            render json: { success: false, message: "Usuario o contraseña incorrecta."}
        end
    end

end
