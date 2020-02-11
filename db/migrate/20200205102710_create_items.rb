class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string      :name
      t.text        :description
      t.integer     :price
      # t.integer     :business_result
      # t.string      :status
      # t.references  :user,               null: false
      # t.references  :category,           null: false
      # t.references  :brand,              null: false
      # t.references  :delivery_style,     null: false
      # t.integer     :buyer_id
      t.timestamps
    end
  end
end
