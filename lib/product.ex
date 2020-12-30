defmodule Product do
  @moduledoc """
  Modulo Product onde faz todas as operacoes em produtos, como registrar um produto, deletar, atualizar, etc.

  Funcao mais utilizada `Product.register_product/5`
  """
  defstruct name: nil, description: nil, category: nil, price: nil, stock: nil

  @categorys_path "categorys"

  @doc """
  Funcao que registra um novo produto

  ## Parametros da funcao

  - name: nome do produto
  - description: descricao do novo produto
  - price: preco
  - category: categoria que ele ira pertencer
  - stock: quantos produtos tera no estoque

  ## Informacoes adicionais

  - Se a categoria que o produto esta sendo cadastrado nao existir, retona uma tupla com erro e mensagem

  ## Exemplo

      iex> Product.register_product("Teste", "Linda cadeira", "1200", "Cadeira", 5)
      {:error, "Categoria inesistente"}
  """
  def register_product(name, description, price, category, stock) do
    cond do
      Categorys.category_exists(category) == true ->
        (read(category) ++
           [
             %__MODULE__{
               name: name,
               description: description,
               category: category,
               price: price,
               stock: stock
             }
           ])
        |> :erlang.term_to_binary()
        |> write(category)

        {:ok, "Produto #{name} cadastrado com sucesso na categoria #{category}!"}

      Categorys.category_exists(category) == false ->
        {:error, "Categoria inesistente"}
    end
  end

  defp write(list_products, category) do
    File.write("#{@categorys_path}/#{category}.txt", list_products)
  end

  @doc """
  Funcao le o arquivo de uma categoria e devolve o seu conteudo

  ## Parametro da funcao

  - category: nome da categoria que sera lida

  ## Informacoes adicionais

  - Se a categoria nao existir, retona uma tupla com erro e mensagem

  ## Exemplo

      iex> Product.read("Teste")
      {:error, "Categoria Teste nao registrada!"}
  """
  def read(category) do
    case File.read("#{@categorys_path}/#{category}.txt") do
      {:ok, products} ->
        products
        |> :erlang.binary_to_term()

      {:error, :enoent} ->
        {:error, "Categoria #{category} nao registrada!"}
    end
  end

  @doc """
  Funcao retorna insformacoes dos produtos de uma determinada categoria

  ## Parametro da funcao

  - category: categoria que deseja ver os produtos
  """
  def read_products_category(category) do
    category
    |> read()
    |> Enum.each(&echo/1)
  end

  @doc """
  Funcao retorna insformacoes de um determinado produto de uma determinada categoria

  ## Parametro da funcao

  - name: nome do produto
  - category: categoria que deseja ver os produtos
  """
  def read_product(name, category) do
    category
    |> read()
    |> Enum.find(&(&1.name === name))
    |> echo()
  end

  @doc """
  Funcao deleta um produto especifico

  ## Parametros da funcao

  - name: nome do produto
  - category: categoria que deseja deletar o produto
  """
  def delete_product(name, category) do
    list_category =
      category
      |> read()

    product_delete =
      list_category
      |> Enum.find(&(&1.name === name))

    list_category
    |> List.delete(product_delete)
    |> :erlang.term_to_binary()
    |> write(category)

    {:ok, "Produto #{name} da categoria #{category} deletado com sucesso!"}
  end

  @doc """
  Funcao atualiza um produto com um novo valor em um atributo que desejar

  ## Parametros da funcao

  - name: nome do produto
  - category: categoria do produto a ser atualizado
  - attr: atributo que deseja atualizar o valor
  - new_value: novo valor que o atributo recebera
  """
  def update_product(name, category, attr, new_value) do
    updated_product =
      category
      |> read()
      |> Enum.find(&(&1.name === name))
      |> update_atribute(attr, new_value)

    old_product =
      category
      |> read()
      |> Enum.find(&(&1.name === name))

    category
    |> read()
    |> List.delete(old_product)
    |> List.insert_at(0, updated_product)
    |> :erlang.term_to_binary()
    |> write(category)

    {:ok,
     "Produto #{old_product.name} com atualicação no atributo #{attr} agora ta com: #{new_value}"}
  end

  defp update_atribute(product, attr, new_value) do
    %{product | "#{attr}": new_value}
  end

  defp echo(product) do
    IO.puts("--------------------------------")
    IO.puts("Nome: #{product.name}")
    IO.puts("Descrição: #{product.description}")
    IO.puts("Preço: #{product.price}")
    IO.puts("----------------------------------")
  end
end
