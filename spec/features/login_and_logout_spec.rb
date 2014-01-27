require 'spec_helper'

describe 'ログイン' do
  specify 'ユーザー認証成功' do
    visit root_path
    within('form#new_session') do
      fill_in 'username', with: 'taro'
      fill_in 'password', with: 'correct_password'
      click_button 'ログイン'
    end
    expect(page).not_to have_css('form#new_session')
  end

  specify 'ユーザー認証失敗' do
    visit root_path
    within('form#new_session') do
      fill_in 'username', with: 'taro'
      fill_in 'password', with: 'wrong_password'
      click_button 'ログイン'
    end
    expect(page).to have_css('p.alert', text: 'ユーザー名またはパスワードが正しくありません。')
    expect(page).to have_css('form#new_session')
  end
end