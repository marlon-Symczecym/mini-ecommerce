defmodule ClientTest do
  use ExUnit.Case
  doctest Client

  @client_filepath "clients"
  @client_file "clients.txt"
  @client_path "#{@client_filepath}/#{@client_file}"

  setup do
    File.mkdir(@client_path)
    File.write(@client_path, :erlang.term_to_binary([]))
  end

  test "deve testar a estrutura de dados" do
    assert %Client{
             name: "Teste",
             cpf: "1234",
             telephone: "55551211",
             country: "Teste",
             state: "Teste",
             city: "Teste",
             district: "Teste",
             street: "Teste",
             house_number: "123"
           }.cpf == "1234"
  end

  test "deve registrar um cliente" do
    assert Client.register_client(
             "Teste",
             "1234",
             "55551211",
             "Teste",
             "Teste",
             "Teste",
             "Teste",
             "Teste",
             "123"
           ) == {:ok, "Cliente Teste registrado com sucesso"}
  end

  test "nao deve registrar um cliente com cpf iguais" do
    Client.register_client(
      "Teste",
      "1234",
      "55551211",
      "Teste",
      "Teste",
      "Teste",
      "Teste",
      "Teste",
      "123"
    )

    assert Client.register_client(
             "Teste",
             "1234",
             "55551211",
             "Teste",
             "Teste",
             "Teste",
             "Teste",
             "Teste",
             "123"
           ) == {:error, "Ja existe cliente cadastrado com esse CPF: 1234"}
  end

  test "deve imprimir todos os clientes" do
    Client.register_client(
      "Maria",
      "1234",
      "55551211",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "123"
    )

    Client.register_client(
      "Josue",
      "7787",
      "12345345",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "56456"
    )

    assert Client.show_all() == :ok
  end

  test "deve imprimir um cliente em especifico" do
    Client.register_client(
      "Josue",
      "7787",
      "12345345",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "56456"
    )

    assert Client.show_client("Josue", "7787") == :ok
  end

  test "deve imprimir informacoes das compras do cliente" do
    Ecommerce.register_category("Poltronas")
    Ecommerce.register_product("Poltrona alta", "Linda Poltrona", 1200, "Poltronas", 5)

    Client.register_client(
      "Maria",
      "1234",
      "55551211",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "123"
    )

    Purchase.buy("Maria", "1234", "Poltrona alta", "Poltronas", 3)
    Purchase.buy("Maria", "1234", "Poltrona alta", "Poltronas", 1)
    Purchase.buy("Maria", "1234", "Poltrona alta", "Poltronas", 1)

    assert Client.show_purchases_client("Maria", "1234") == :ok
  end

  test "deve deletar um cliente" do
    Client.register_client(
      "Josue",
      "7787",
      "12345345",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "56456"
    )

    assert Client.delete_client("Josue", "7787") == {:ok, "Josue com CPF: 7787 foi deletado"}
    assert Client.show_all() == {:error, "Sem clientes cadastrasdos"}
  end

  test "deve atualizar informacoes de um cliente" do
    Client.register_client(
      "Josue",
      "7787",
      "12345345",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "Teste2",
      "56456"
    )

    Client.register_client(
      "Andre",
      "1234",
      "55551211",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "123"
    )

    assert Client.update_client("Josue", "7787", "name", "Maria") ==
             {:ok, "Cliente Josue com CPF: 7787, atualizou: name: Josue, para: nome: Maria"}

    assert Client.read() |> Enum.count() == 2
  end
end
