class AddSystemCodeToComponentSelections < ActiveRecord::Migration[8.0]
  def change
    add_column :component_selections, :system_code, :string, limit: 10
    add_index :component_selections, :system_code
  end
end
