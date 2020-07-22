class ChangeZipcodeToBeStringInAddresses < ActiveRecord::Migration[5.0]
  def change
    change_column :addresses, :zip_code, :string
  end
end
