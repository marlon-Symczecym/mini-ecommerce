defmodule Client do
  @moduledoc """
  Modulo Client faz relacao a conta de um cliente
  """

  @client_filepath "clients"
  @client_file "clients.txt"
  @client_path "#{@client_filepath}/#{@client_file}"

  defstruct name: nil,
            cpf: nil,
            telephone: nil,
            country: nil,
            state: nil,
            city: nil,
            district: nil,
            street: nil,
            house_number: nil,
            value_spent: 0,
            purchase: []

  @doc """
  Funcao faz o registro de um novo cliente na base de dados

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf
  - tel: numero de telefone
  - country: nome do País
  - state: nome do estado
  - city: nome da cidade
  - district: nome do bairro
  - street: nome da rua
  - house_number: numero da casa
  """
  def register_client(name, cpf, tel, country, state, city, district, street, house_number) do
    (read() ++
       [
         %__MODULE__{
           name: name,
           cpf: cpf,
           telephone: tel,
           country: country,
           state: state,
           city: city,
           district: district,
           street: street,
           value_spent: 0,
           house_number: house_number
         }
       ])
    |> :erlang.term_to_binary()
    |> write()

    {:ok, "Cliente #{name} registrado com sucesso"}
  end

  def write(list_clients) do
    File.write(@client_path, list_clients)
  end

  @doc """
  Funcao que le o arquivo dos clientes e retorna os dados transformados em texto
  """
  def read() do
    {:ok, file} = File.read(@client_path)

    file
    |> :erlang.binary_to_term()
  end

  @doc """
  Funcao que mostra todos os clientes cadastrados na base de dados
  """
  def show_all() do
    cond do
      read() |> Enum.count() == 0 ->
        {:error, "Sem clientes cadastrasdos"}

      read() |> Enum.count() > 0 ->
        read()
        |> Enum.each(&echo/1)
    end
  end

  @doc """
  Funcao que imprime um cliente em especifico

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf do cliente
  """
  def show_client(name, cpf) do
    case read() |> Enum.find(&(&1.name == name && &1.cpf == cpf)) do
      nil ->
        {:error, "Cliente nao encontrado"}

      _ ->
        read()
        |> Enum.find(&(&1.name == name && &1.cpf == cpf))
        |> echo()
    end
  end

  @doc """
  Funcao que retorna um cliente em especifico

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf do cliente
  """
  def find_client(name, cpf) do
    case read() |> Enum.find(&(&1.name == name && &1.cpf == cpf)) do
      nil ->
        {:error, "Cliente nao encontrado"}

      _ ->
        read()
        |> Enum.find(&(&1.name == name && &1.cpf == cpf))
    end
  end

  @doc """
  Funcao que retorna as compras feitas por um cliente em especifico

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf do cliente
  """
  def find_purchases_client(name, cpf) do
    case read() |> Enum.find(&(&1.name == name && &1.cpf == cpf)) do
      nil ->
        {:error, "Cliente nao encontrado"}

      _ ->
        client =
          read()
          |> Enum.find(&(&1.name == name && &1.cpf == cpf))

        {:ok, purchases} = Map.fetch(client, :purchase)

        purchases
    end
  end

  @doc """
  Funcao para exibir informacoes das compras de um cliente

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf do cliente
  """
  def show_purchases_client(name, cpf) do
    client = read() |> Enum.find(&(&1.name == name && &1.cpf == cpf))

    case client do
      nil ->
        {:error, "Cliente nao encontrado"}

      _ ->
        client =
          read()
          |> Enum.find(&(&1.name == name && &1.cpf == cpf))

        {:ok, purchases} = Map.fetch(client, :purchase)

        purchases
        |> Enum.each(&echo_purchases/1)
    end
  end

  @doc """
  Funcao que deleta um cliente em especifico

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf do cliente
  """
  def delete_client(name, cpf) do
    find_client = read() |> Enum.find(&(&1.name == name && &1.cpf == cpf))

    cond do
      find_client == nil ->
        {:error, "Cliente nao encontrado"}

      find_client !== nil ->
        client = [find_client]

        delete_item(client)
        |> :erlang.term_to_binary()
        |> write()

        {:ok, "#{name} com CPF: #{cpf} foi deletado"}
    end
  end

  @doc """
  Funcao que atualiza algum atributo de um cliente em especifico

  ## Parametros da funcao

  - name: nome do cliente
  - cpf: numero do cpf do cliente
  - attr: atributo que deseja atualizar
  - new_value: o novo valor para o atributo selecionado
  """
  def update_client(name, cpf, attr, new_value) do
    find_client = read() |> Enum.find(&(&1.name == name && &1.cpf == cpf))

    client =
      [find_client]
      |> delete_item()

    (client ++ [%{find_client | "#{attr}": new_value}])
    |> :erlang.term_to_binary()
    |> write()

    {:ok,
     "Cliente #{name} com CPF: #{cpf}, atualizou: #{attr}: #{name}, para: nome: #{new_value}"}
  end

  defp delete_item(client) do
    client
    |> Enum.reduce(read(), fn x, acc -> List.delete(acc, x) end)
  end

  defp echo(client) do
    IO.puts("================")
    IO.puts("Nome: #{client.name}")
    IO.puts("CPF: #{client.cpf}")
    IO.puts("Telefone: #{client.telephone}")
    IO.puts("País: #{client.country}")
    IO.puts("Estado: #{client.state}")
    IO.puts("Cidade: #{client.city}")
    IO.puts("Bairro: #{client.district}")
    IO.puts("Rua: #{client.street}")
    IO.puts("Numero da casa: #{client.house_number}")
    IO.puts("Numero de compras: #{client.purchase |> Enum.count()}")
    IO.puts("Valor gasto: R$ #{client.value_spent} reais")
  end

  defp echo_purchases(product) do
    IO.puts("================")
    IO.puts("Nome: #{product.name}")
    IO.puts("Descrição: #{product.description}")
    IO.puts("Preço: R$ #{product.price} reais")
    IO.puts("Quantidade: #{product.stock}")
  end
end
