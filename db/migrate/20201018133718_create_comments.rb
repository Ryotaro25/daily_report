class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :micropost, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
    add_index :comments , [:user_id, :micropost_id, :created_at]
  end
end
