require 'spec_helper'

describe Customer, 'バリデーション' do
  let(:customer) { FactoryGirl.build(:customer) }

  specify '妥当なオブジェクト' do
    expect(customer).to be_valid
  end

  %w{family_name given_name family_name_kana given_name_kana}.each do |column_name|
    specify "#{column_name} は空であってはならない" do
      customer[column_name] = ''
      expect(customer).not_to be_valid
      expect(customer.errors[column_name]).to be_present
    end

    specify "#{column_name} は40文字以内" do
      customer[column_name] = 'ア' * 41
      expect(customer).not_to be_valid
      expect(customer.errors[column_name]).to be_present
    end

    specify "#{column_name} に含まれる半角カナは全角カナに変換して受け入れる" do
      customer[column_name] = 'ｱｲｳ'
      expect(customer).to be_valid
      expect(customer[column_name]).to eq('アイウ')
    end
  end

  %w{family_name given_name}.each do |column_name|
    specify "#{column_name} は漢字、ひらなが、カタカナを含んでもよい" do
      customer[column_name] = '亜あア'
      expect(customer).to be_valid
    end

    specify "#{column_name} は漢字、ひらなが、カタカナ以外の文字を含まない" do
      ['A', '1', '@'].each do |value|
        customer[column_name] = value
        expect(customer).not_to be_valid
        expect(customer.errors[column_name]).to be_present
      end
    end
  end

  %w{family_name_kana given_name_kana}.each do |column_name|
    specify "#{column_name} はカタカナを含んでもよい" do
      customer[column_name] = 'アイウ'
      expect(customer).to be_valid
    end

    specify "#{column_name} はカタカナ以外の文字を含まない" do
      ['亜', 'A', '1', '@'].each do |value|
        customer[column_name] = value
        expect(customer).not_to be_valid
        expect(customer.errors[column_name]).to be_present
      end
    end

    specify "#{column_name} に含まれるひらがなはカタカナに変換して受け入れる" do
      customer[column_name] = 'あいう'
      expect(customer).to be_valid
      expect(customer[column_name]).to eq('アイウ')
    end
  end
end


describe Customer, 'password=' do
  let(:customer) { build(:customer, username: 'taro') }

  specify '生成されたpassword_digestは60文字' do
    customer.password = 'any_string'
    customer.save!
    expect(customer.password_digest).not_to be_nil
    expect(customer.password_digest.size).to eq(60)
  end

  specify '空文字を与えるとpassword_digestはnil' do
    customer.password = ''
    customer.save!
    expect(customer.password_digest).to be_nil
  end
end

describe Customer, '.authenticate' do
  let(:customer) { FactoryGirl.create(:customer, username: 'taro', password: 'correct_password') }

  specify 'ユーザー名とパスワードに該当するCustomerオブジェクトを返す' do
    result = Customer.authenticate(customer.username, 'correct_password')
    expect(result).to eq(customer)
  end

  specify 'パスワードが一致しない場合はnilを返す' do
    result = Customer.authenticate(customer.username, 'wrong_password')
    expect(result).to be_nil
  end

  specify '該当するユーザー名が存在しない場合はnilを返す' do
    result = Customer.authenticate('hanako', 'any_password')
    expect(result).to be_nil
  end

  specify 'パスワード未設定のユーザーを拒絶する' do
    customer.update_column(:password_digest, nil)
    result = Customer.authenticate(customer.username, '')
    expect(result).to be_nil
  end
end