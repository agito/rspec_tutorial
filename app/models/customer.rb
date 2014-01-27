class Customer < ActiveRecord::Base
  validates :family_name, :given_name, :family_name_kana, :given_name_kana, presence: true, length: { maximum: 40 }
end
