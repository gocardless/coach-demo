# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :access_token, null: false
      t.string :permissions, array: true

      t.timestamps
    end
  end
end
