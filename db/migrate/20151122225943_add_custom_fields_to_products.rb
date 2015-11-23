class AddCustomFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :custom_seller_id, :integer
    add_column :products, :custom_company_name, :string
    add_column :products, :custom_company_logo, :string
    add_column :products, :custom_result, :string
  end
end
