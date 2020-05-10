class Api::V1::AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    unless @user
      render json: { error: "The email doesn't exist" }, status: :unauthorized
    else
      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       email: @user.email }, status: :ok
      else
        render json: { error: 'Invalid password' }, status: :unauthorized
      end
    end
  end

  private

  def validate_email(email)
  end

  def login_params
    params.permit(:email, :password)
  end

end
