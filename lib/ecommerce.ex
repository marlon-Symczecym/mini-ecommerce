defmodule Ecommerce do
  @moduledoc """
  Modulo Ecommerce faz todas as chamadas a funcoes do modulo `Categorys` e `Product`

  A funcao mais utilizada `Ecommerce.read_product/2`
  """
  @categorys_path "categorys"
  @client_filepath "clients"
  @client_file "clients.txt"
  @client_path "#{@client_filepath}/#{@client_file}"

  @doc """
  Funcao que criara a pasta onde ira ficar os registros de categorias e produtos
  """
  def start do
    File.mkdir(@categorys_path)
    File.mkdir(@client_filepath)
    File.write(@client_path, :erlang.term_to_binary([]))
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
    cond do
      File.exists?(@categorys_path) == true ->
        Categorys.register_category(category)

      File.exists?(@categorys_path) == false ->
        start()
        Categorys.register_category(category)
    end
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

  @doc """
  Funcao para registrar um novo cliente, chamando a funcao `Client.register_client/9`
  """
  def register_client(name, cpf, tel, country, state, city, district, street, house_number) do
    Client.register_client(name, cpf, tel, country, state, city, district, street, house_number)
  end

  @doc """
  Funcao para mostrar todos os clientes cadastrados, chamando a funcao `Client.show_all/0`
  """
  def show_all(), do: Client.show_all()

  @doc """
  Funcao para mostrar um cliente em especifico, chamando a funcao `Client.show_client/2`
  """
  def show_client(name, cpf), do: Client.show_client(name, cpf)

  @doc """
  Funcao para exibir informacoes das compras de um cliente, chamando a funcao `Client.show_purchases_client/2`
  """
  def show_purchases_client(name, cpf), do: Client.show_purchases_client(name, cpf)

  @doc """
  Funcao que deleta um cliente em especifico, chamando a funcao `Client.delete_client/2`
  """
  def delete_client(name, cpf), do: Client.delete_client(name, cpf)

  @doc """
  Funcao que atualiza algum atributo de um cliente em especifico, chamando a funcao `Client.update_client/5`
  """
  def update_client(name, cpf, attr, new_value) do
    Client.update_client(name, cpf, attr, new_value)
  end

  @doc """
  Funcao para fazer a compra de um produto, chamando a funcao `Purchase.buy/5`
  """
  def buy(name_client, cpf, name_product, category, qtd) do
    Purchase.buy(name_client, cpf, name_product, category, qtd)
  end
end
