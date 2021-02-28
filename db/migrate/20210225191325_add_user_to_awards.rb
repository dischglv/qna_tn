class AddUserToAwards < ActiveRecord::Migration[6.1]
  def change
    add_reference :awards, :user, null: true, foreign_key: true
  end
end
