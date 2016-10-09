class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.index  :email, unique: true
      t.string :password_digest
      t.references :backend_user, polymorphic: true, index: true
      t.references :user,                            index: true
      t.timestamps
    end
  end
end
