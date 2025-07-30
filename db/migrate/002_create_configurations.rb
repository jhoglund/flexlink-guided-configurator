class CreateConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :configurations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :status, default: 'draft'
      t.decimal :total_price, precision: 10, scale: 2, default: 0.0
      t.jsonb :system_specifications, default: {}
      t.jsonb :selected_components, default: {}
      t.jsonb :optimization_results, default: {}
      t.jsonb :wizard_progress, default: {}
      t.integer :current_step, default: 1
      t.boolean :completed, default: false
      t.datetime :completed_at
      t.string :export_format
      t.text :export_data
      t.datetime :exported_at

      t.timestamps null: false
    end

    add_index :configurations, :status
    add_index :configurations, :current_step
    add_index :configurations, :completed
    add_index :configurations, :system_specifications, using: :gin
    add_index :configurations, :selected_components, using: :gin
    add_index :configurations, :optimization_results, using: :gin
    add_index :configurations, :wizard_progress, using: :gin
  end
end 