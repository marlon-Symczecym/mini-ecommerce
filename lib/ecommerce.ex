defmodule Ecommerce do
  def start do
    File.mkdir("categorys")
    File.cd("categorys")
    File.write("all.txt", :erlang.term_to_binary([]))
  end

  def show_categorys do
    Categorys.show_info_categorys()
  end

  def register_category(category) do
    Categorys.register_category(category)
  end

  def rename_file_category(old_category, new_category) do
    Categorys.rename_file_category(old_category, new_category)
  end

  def delete_category(category) do
    Categorys.delete_category(category)
  end

  def register_product(name, description, price, category) do
    Product.register_product(name, description, price, category)
  end

  def read_product(name, category) do
    Product.read_product(name, category)
  end

  def read_products_category(category) do
    Product.read_products_category(category)
  end

  def delete_product(name, category) do
    Product.delete_product(name, category)
  end
end
