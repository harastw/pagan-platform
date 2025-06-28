class CreateTexts < ActiveRecord::Migration[8.0]
  def change
    create_table :texts do |t|
      t.string :title
      t.text :content
      t.string :language
      t.string :period

      t.timestamps
    end
  end
end
