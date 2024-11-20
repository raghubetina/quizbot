class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :role
      t.text :content
      t.integer :quiz_id

      t.timestamps
    end
  end
end
