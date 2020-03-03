class UsersController < ApplicationController
before_action :authorized, only: [:persist]


  def create
    @user = User.create(user_params)
    if @user.valid? 
      wristband = encode_token({user_id: @user.id})
      render json: { user: UserSerializer.new(@user), token: wristband }, status: 201
    else
    render json: {error: "Oh no you diiiddn't"}  
    end
  end


  def login
    @user = User.find_by(username: params[:username])
    
    if @user && @user.authenticate(params[:password])
      wristband = encode_token({user_id: @user.id})
      render json: { user: UserSerializer.new(@user), token: wristband }
    else 
      render json: {error: "Thats not you!"} 
    end
  end


  def persist
    wristband = encode_token({user_id: @user.id})
    render json: { user: UserSerializer.new(@user), token: wristband }
  end 


private

def user_params
  params.permit(:username, :password)
end


end
