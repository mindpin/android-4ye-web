class CreateUserSecrets < ActiveRecord::Migration
  def change
    create_table :user_secrets do |t|
      t.integer :user_id
      t.string :secret
      t.timestamps
    end
  end
end
