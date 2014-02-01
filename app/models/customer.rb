require 'nkf'
require 'bcrypt'

class Customer < ActiveRecord::Base
  has_many :rewards

  attr_accessor :password

  validates :family_name, :given_name, :family_name_kana, :given_name_kana,
            presence: true, length: { maximum: 40 }
  validates :family_name, :given_name,
            format: { with: /\A[\p{Han}\p{Hiragana}\p{Katakana}]+\z/, allow_blank: true }
  validates :family_name_kana, :given_name_kana,
            format: { with: /\A\p{Katakana}+\z/, allow_blank: true }

  before_validation do
    self.family_name = NKF.nkf('-w', family_name) if family_name
    self.given_name = NKF.nkf('-w', given_name) if given_name
    self.family_name_kana = NKF.nkf('-wh2', family_name_kana) if family_name_kana
    self.given_name_kana = NKF.nkf('-wh2', given_name_kana) if given_name_kana
  end

  before_save do
    self.password_digest = BCrypt::Password.create(password) if password.present?
  end

  def points
    rewards.sum(:points)
  end
end