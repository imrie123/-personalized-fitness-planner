# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @response = FirebaseService::SignUp.new(user_params[:email], user_params[:password]).call
    return unless @response['idToken']

    @user = User.new(user_params)
    if @user.save

      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def sign_in
    @response = FirebaseService::SignIn.new(user_params[:email], user_params[:password]).call
    if @response['idToken']
      @user = User.find_by(email: user_params[:email])
      render 'sign_in', formats: :json, handlers: :jbuilder, status: :ok
    else
      @error = @response['error']['message']
      render 'error', formats: :json, handlers: :jbuilder, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
