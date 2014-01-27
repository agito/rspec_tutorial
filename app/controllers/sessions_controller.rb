class SessionsController < ApplicationController
  def create
    if false
      # 未実装
    else
      flash.alert = 'ユーザー名またはパスワードが正しくありません。'
    end
    redirect_to :root
  end
end