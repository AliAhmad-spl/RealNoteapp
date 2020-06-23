class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :description
      t.datetime :start
      t.datetime :end
      t.string :event
      t.string :members
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
