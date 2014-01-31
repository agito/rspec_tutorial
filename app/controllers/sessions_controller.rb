class SessionsController < ApplicationController
  def create
    if customer = Customer.authenticate(params[:username], params[:password])
      session[:customer_id] = customer.id
    else
      flash.alert = 'ユーザー名またはパスワードが正しくありません。'
    end
    redirect_to :root
  end
end