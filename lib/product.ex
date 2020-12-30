defmodule Product do
  @moduledoc """

  """
  defstruct name: nil, description: nil, category: nil, price: nil, stock: nil

  @categorys_path "categorys"

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

  def read(category) do
    case File.read("#{@categorys_path}/#{category}.txt") do
      {:ok, products} ->
        products
        |> :erlang.binary_to_term()

      {:error, :enoent} ->
        {:error, "Categoria #{category} nao registrada!"}
    end
  end

  def read_products_category(category) do
    category
    |> read()
    |> Enum.each(&echo/1)
  end

  def read_product(name, category) do
    category
    |> read()
    |> Enum.find(&(&1.name === name))
    |> echo()
  end

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

  def update_product(name, new_value, category, attr) do
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
