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
           house_number: house_number
         }
       ])
    |> :erlang.term_to_binary()
    |> write()

    {:ok, "Cliente #{name} registrado com sucesso"}
  end

  defp write(list_clients) do
    File.write(@client_path, list_clients)
  end

  defp read() do
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

  def delete_client(name, cpf) do
    meet_client = read() |> Enum.find(&(&1.name == name && &1.cpf == cpf))

    cond do
      meet_client == nil ->
        {:error, "Cliente nao encontrado"}

      meet_client !== nil ->
        client = [
          read()
          |> Enum.find(&(&1.name == name && &1.cpf == cpf))
        ]

        delete_item(client)
        |> :erlang.term_to_binary()
        |> write()

        {:ok, "#{name} com CPF: #{cpf} foi deletado"}
    end
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
  end
end
