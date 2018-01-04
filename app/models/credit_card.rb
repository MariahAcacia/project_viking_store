class CreditCard < ApplicationRecord

  belongs_to :user
  validates :card_number, presence: true, length: { minimum: 8,
                                                    maximum: 19 }
  validates :user_id, :exp_month, :exp_year, presence: true
  validates :ccv, presence: true, length: { minimum: 3,
                                            maximum: 4 }

end
