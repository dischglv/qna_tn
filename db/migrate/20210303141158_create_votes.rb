class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.boolean :value, null: false
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
