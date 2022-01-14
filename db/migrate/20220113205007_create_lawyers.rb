class CreateLawyers < ActiveRecord::Migration[7.0]
  def change
    create_table :lawyers do |t|
      t.string :email
      t.string :name
      t.string :surname

      t.timestamps
    end
  end
end
