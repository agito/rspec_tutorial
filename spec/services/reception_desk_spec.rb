require 'spec_helper'
require 'receptio_desk'

describe ReceptionDesk, '#sign_in' do
  let(:customer) { create(:customer, username: 'taro', password: 'correct_password') }

  context 'ユーザー名とパスワードが一致する場合' do
    specify do
      expect_any_instance_of(RewardManager).to receive(:grant_login_points)
      result = ReceptionDesk.new(customer.username, 'correct_password').sign_in
      expect(result).to eq(customer)
    end
  end

  context '該当するユーザー名が存在しない場合' do
    specify do
      expect_any_instance_of(RewardManager).not_to receive(:grant_login_points)
      result = ReceptionDesk.new('hanako', 'any_string').sign_in
      expect(result).to be_nil
    end
  end

  context 'パスワードが一致しない場合' do
    specify do
      expect_any_instance_of(RewardManager).not_to receive(:grant_login_points)
      result = ReceptionDesk.new(customer.username, 'wrong_password').sign_in
      expect(result).to be_nil
    end
  end

  context 'パスワード未設定の場合' do
    before { customer.update_column(:password_digest, nil) }

    specify do
      expect_any_instance_of(RewardManager).not_to receive(:grant_login_points)
      result = ReceptionDesk.new(customer.username, '').sign_in
      expect(result).to be_nil
    end
  end
end  