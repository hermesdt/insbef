class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.references :query, index: true
      t.text :text

      t.timestamps
    end
  end
end
