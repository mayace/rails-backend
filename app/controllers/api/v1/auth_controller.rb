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

    def get_hash_secret(username)
        client_secret = ENV["COGNITO_CLIENT_SECRET"]
        client_id = ENV["COGNITO_CLIENT_ID"]
        # puts client_secret, client_id
        data = username + client_id
        puts data +"\n"
        digest = OpenSSL::HMAC.digest('SHA256', client_secret, username + client_id)
        Base64.strict_encode64(digest)
    end

    def cognito_login
        cognito = get_cognito()
        username = params[:auth][:username]
        password = params[:auth][:password]
        hash_secret = get_hash_secret(username)
        # puts hash_secret
        res = cognito.admin_initiate_auth({
            user_pool_id: ENV["COGNITO_POOL_ID"], # required
            client_id: ENV["COGNITO_CLIENT_ID"], # required
            auth_flow: "ADMIN_USER_PASSWORD_AUTH",
            auth_parameters: {
                "USERNAME" => username,
                "PASSWORD" => password,
                "SECRET_HASH" => hash_secret
            }
        })

        # puts res
        render json: { success: true, data: params}
    end




end
