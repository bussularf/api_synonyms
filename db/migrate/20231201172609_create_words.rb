class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :reference

      t.timestamps
    end
  end
end
