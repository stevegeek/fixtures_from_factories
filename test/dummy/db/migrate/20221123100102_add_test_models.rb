class AddTestModels < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
    end

    create_table :posts do |t|
      t.string :title
      t.datetime :published_at
      t.references :user, foreign_key: true
    end

    create_table :categories do |t|
      t.string :name
    end

    create_table :tags do |t|
      t.string :name
    end

    create_join_table :posts, :categories
    create_join_table :posts, :tags
  end
end
