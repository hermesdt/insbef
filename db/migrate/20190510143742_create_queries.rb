class CreateQueries < ActiveRecord::Migration[5.2]
  def change
    enable_extension "hstore"
    create_table :queries do |t|
      t.string :query_type
      t.hstore :parameters

      t.timestamps
    end
  end
end
