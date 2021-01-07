defmodule Purchase do
  @moduledoc """
  Modulo Purchase sera reponsavel por realizar as compras e lista-las
  """

  @doc """
  Funcao responsavel por realizar uma compra

  ## Parametros da funcao

  - name_client: nome do cliente que fara a compra
  - cpf: cpf do cliente
  - name_product: nome do produto que o cliente estar a comprando
  - qtd: quantidade que ira comprar
  """
  def buy(name_client, cpf, name_product, category, qtd) do
    client = Client.find_client(name_client, cpf)
    product = Product.find_product(name_product, category)

    case Client.find_client(name_client, cpf) do
      {:error, "Cliente nao encontrado"} ->
        {:error, "Cliente nao encontrado"}

      _ ->
        cond do
          product.stock >= 1 ->
            [
              %Client{
                client
                | purchase:
                    Client.find_purchases_client(name_client, cpf) ++
                      [%Product{product | stock: qtd}],
                  value_spent: client.value_spent + product.price * qtd
              }
            ]
            |> :erlang.term_to_binary()
            |> Client.write()

            Product.update_product(product.name, product.category, "stock", product.stock - qtd)
            {:ok, "Cliente #{name_client} acabou de comprar #{qtd} #{name_product} !"}

          product.stock <= 0 ->
            {:error, "Produto esta fora de estoque !"}
        end
    end
  end
end
