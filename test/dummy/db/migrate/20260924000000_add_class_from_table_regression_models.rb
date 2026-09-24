class AddClassFromTableRegressionModels < ActiveRecord::Migration[7.0]
  def change
    # "offers_settings".classify is "OffersSetting", not the model OffersSettings.
    create_table :offers_settings do |t|
      t.references :user, null: false, foreign_key: true
    end

    # A table with no model at all.
    create_table :post_reactions, id: false do |t|
      t.integer :post_id, null: false
      t.string :emoji, null: false
    end

    # A HABTM join table (User <-> Tag) with no model of its own.
    create_table :tags_users, id: false do |t|
      t.integer :tag_id, null: false
      t.integer :user_id, null: false
    end
  end
end
