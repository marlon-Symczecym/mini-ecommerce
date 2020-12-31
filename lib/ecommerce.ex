defmodule Ecommerce do
  @moduledoc """
  Modulo Ecommerce faz todas as chamadas a funcoes do modulo `Categorys` e `Product`

  A funcao mais utilizada `Ecommerce.read_product/2`
  """

  @doc """
  Funcao que criara a pasta onde ira ficar os registros de categorias e produtos
  """
  def start do
    File.mkdir("categorys")
    {:ok, "Pasta de categorias criada com sucesso!"}
  end

  @doc """
  Funcao que mostra todas as categorias cadastradas, chamando a funcao `Categorys.show_info_categorys/0`
  """
  def show_categorys do
    Categorys.show_info_categorys()
  end

  @doc """
  Funcao que faz o registro de uma nova categoria, chamando a funcao `Categorys.register_category/1`
  """
  def register_category(category) do
    Categorys.register_category(category)
  end

  @doc """
  Funcao que renomeia uma categoria existente, chamando a funcao `Categorys.rename_file_category/2`
  """
  def rename_file_category(old_category, new_category) do
    Categorys.rename_file_category(old_category, new_category)
  end

  @doc """
  Funcao que deleta uma categoria existente, chamando a funcao `Categorys.delete_category/1`
  """
  def delete_category(category) do
    Categorys.delete_category(category)
  end

  @doc """
  Funcao que registra um novo produto, chamando a funcao `Product.register_product/5`
  """
  def register_product(name, description, price, category, stock) do
    Product.register_product(name, description, price, category, stock)
  end

  @doc """
  Funcao que mostra informacoes de um determinado produto de uma categoria especifica, chamando a funcao `Product.read_product/2`
  """
  def read_product(name, category) do
    Product.read_product(name, category)
  end

  @doc """
  Funcao que mostra informacoes de todos os produto de uma categoria especifica, chamando a funcao `Product.read_products_category/1`
  """
  def read_products_category(category) do
    Product.read_products_category(category)
  end

  @doc """
  Funcao que deleta um produto de uma categoria especifica, chamando a funcao `Product.delete_product/2`
  """
  def delete_product(name, category) do
    Product.delete_product(name, category)
  end

  @doc """
  Funcao que atualiza determinado atributo de um produto, chamando a funcao `Product.update_product/4`
  """
  def update_atribute_product(name, category, attr, new_value) do
    Product.update_product(name, category, attr, new_value)
  end
end
