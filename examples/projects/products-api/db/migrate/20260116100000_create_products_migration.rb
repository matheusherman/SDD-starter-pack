class CreateProductsMigration < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :string do |t|
      t.string :title, null: false
      t.text :description
      t.integer :quantity, null: false
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :products, :title
  end
end
