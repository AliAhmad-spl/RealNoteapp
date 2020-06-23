class CreateUsers < ActiveRecord::Migration[5.2]
	def change
	    create_table :users do |t|
	      t.string :email
	      t.string :name
	      t.string :encrypted_password
	      t.string :access_token
	      t.datetime :expires_at
	      t.string :refresh_token
	    end
	end
end