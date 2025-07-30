class CreateComponentSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :component_selections do |t|
      t.references :configuration, null: false, foreign_key: true
      t.string :component_type, null: false
      t.string :component_id, null: false
      t.string :component_name
      t.jsonb :specifications, default: {}
      t.jsonb :options, default: {}
      t.decimal :price, precision: 10, scale: 2
      t.string :currency, default: 'USD'
      t.integer :quantity, default: 1
      t.text :notes
      t.string :status, default: 'selected'
      t.datetime :selected_at

      t.timestamps null: false
    end

    add_index :component_selections, :component_type
    add_index :component_selections, :component_id
    add_index :component_selections, :status
    add_index :component_selections, :specifications, using: :gin
    add_index :component_selections, :options, using: :gin
  end
end 