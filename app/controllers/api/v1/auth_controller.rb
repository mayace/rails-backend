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


    def cognito_signup()
    end

    def cognito_confirm()
        username = params[:username]
        code = params[:code]
        
        cognito_settings = get_cognito_settings()
        hash_secret = get_hash_secret(username)
        options = {
            client_id: cognito_settings[:client_id], # required
            secret_hash: hash_secret,
            username: username, # required
            confirmation_code: code, # required
        }
        cognito = get_cognito()

        resp = cognito.confirm_sign_up(options)

        puts resp
    rescue Aws::CognitoIdentityProvider::Errors::CodeMismatchException => err
        render json: { success: false, message: "#{err}"}

    end

    def cognito_signin()
        cognito = get_cognito()
        username = params[:auth][:username]
        password = params[:auth][:password]
        hash_secret = get_hash_secret(username)
        # puts hash_secret
        resp = cognito.admin_initiate_auth({
            user_pool_id: ENV["COGNITO_POOL_ID"], # required
            client_id: ENV["COGNITO_CLIENT_ID"], # required
            auth_flow: "ADMIN_USER_PASSWORD_AUTH",
            auth_parameters: {
                "USERNAME" => username,
                "PASSWORD" => password,
                "SECRET_HASH" => hash_secret
            }
        })


        render json: { success: true, data: resp.authentication_result}

        rescue Aws::CognitoIdentityProvider::Errors::UserNotConfirmedException => err
            render json: {success: false, message: "#{err}"}
    end

end
