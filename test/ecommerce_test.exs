defmodule EcommerceTest do
  use ExUnit.Case
  doctest Ecommerce

  @client_filepath "clients"
  @client_file "clients.txt"
  @client_path "#{@client_filepath}/#{@client_file}"

  setup do
    File.mkdir("categorys")
    File.mkdir(@client_filepath)
    File.write(@client_path, :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm_rf("categorys")
      # File.rm_rf("clients")
    end)
  end

  test "deve criar a pasta padrao de categorias" do
    Ecommerce.start()
    assert File.exists?("categorys") == true
  end

  test "deve mostrar todas as categorias cadastradas" do
    Categorys.register_category("Teste")
    Categorys.register_category("Teste2")
    Categorys.register_category("Teste3")

    assert Ecommerce.show_categorys() == [:ok, :ok, :ok]
  end

  test "deve registrar uma categoria" do
    assert Ecommerce.register_category("Teste") ==
             {:ok, "Categoria Teste registrado com sucesso!"}
  end

  test "deve criar as pastas padrao" do
    File.rm_rf("categorys")

    assert Ecommerce.register_category("Teste") ==
             {:ok, "Categoria Teste registrado com sucesso!"}
  end

  test "deve renomear uma categoria" do
    Ecommerce.register_category("Teste")

    assert Ecommerce.rename_file_category("Teste", "TesteNovo") ==
             {:ok, "Categoria Teste renomeado para TesteNovo com sucesso!"}
  end

  test "deve deletar uma categoria existente" do
    Ecommerce.register_category("Teste")

    assert Ecommerce.delete_category("Teste") == {:ok, "Categoria Teste deletado com sucesso!"}
  end

  test "deve cadastrar um produto" do
    Ecommerce.register_category("Cadeira")

    assert Ecommerce.register_product(
             "Cadeira alta com braco",
             "Linda cadeira",
             "1200",
             "Cadeira",
             5
           ) ==
             {:ok, "Produto Cadeira alta com braco cadastrado com sucesso na categoria Cadeira!"}
  end

  test "deve imprimir um produto de uma categoria especifica" do
    Ecommerce.register_category("Cadeira")
    Ecommerce.register_product("Cadeira estofada", "Linda cadeira", "1200", "Cadeira", 5)

    assert Ecommerce.read_product("Cadeira estofada", "Cadeira") == :ok
  end

  test "deve imprimir produtos da categoria" do
    Ecommerce.register_category("Cadeira")
    Ecommerce.register_product("Cadeira alta", "Linda cadeira", "1200", "Cadeira", 5)

    assert Ecommerce.read_products_category("Cadeira") == :ok
  end

  test "deve deletar um produto" do
    Ecommerce.register_category("Cadeira")
    Ecommerce.register_product("Cadeira estofada", "Linda cadeira", "1200", "Cadeira", 5)

    assert Ecommerce.delete_product("Cadeira estofada", "Cadeira") ==
             {:ok, "Produto Cadeira estofada da categoria Cadeira deletado com sucesso!"}
  end

  test "deve atualizar um atributo de um produto" do
    Ecommerce.register_category("Cadeira")
    Ecommerce.register_product("Cadeira estofada", "Linda cadeira", "1200", "Cadeira", 5)

    assert Ecommerce.update_atribute_product("Cadeira estofada", "Cadeira", "name", "Teste") ==
             {:ok, "Produto atualizado com sucesso !"}
  end

  test "deve fazer a compra de um produto" do
    Ecommerce.register_category("Cadeiras")
    Ecommerce.register_product("Cadeira alta com listras 2", "Linda cadeira", 1200, "Cadeiras", 5)

    Ecommerce.register_client(
      "Joao",
      "12345",
      "55551211",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "Teste1",
      "123"
    )

    assert Ecommerce.buy("Joao", "12345", "Cadeira alta com listras 2", "Cadeiras", 3) ==
             {:ok, "Cliente Joao acabou de comprar 3 Cadeira alta com listras 2 !"}

    Ecommerce.buy("Joao", "12345", "Cadeira alta com listras 2", "Cadeiras", 1)
    Ecommerce.buy("Joao", "12345", "Cadeira alta com listras 2", "Cadeiras", 1)
    Ecommerce.buy("Joao", "12345", "Cadeira alta com listras 2", "Cadeiras", 1)

    assert Client.find_purchases_client("Joao", "12345") |> Enum.count() == 3
  end

  test "deve mostrar todos os clientes" do
    Ecommerce.register_client(
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

    assert Ecommerce.show_all() == :ok
  end

  test "deve retornar um cliente especifico" do
    Ecommerce.register_client(
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

    assert Ecommerce.show_client("Maria", "1234") == :ok
  end

  test "deve mostrar todas as compras de um cliente" do
    Ecommerce.register_category("Cadeiras")
    Ecommerce.register_product("Cadeira alta com listras 4", "Linda cadeira", 1200, "Cadeiras", 5)

    Ecommerce.register_client(
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

    Purchase.buy("Maria", "1234", "Cadeira alta com listras 4", "Cadeiras", 1)

    assert Ecommerce.show_purchases_client("Maria", "1234") == :ok
  end

  test "deve deletar um cliente" do
    Ecommerce.register_client(
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

    assert Ecommerce.delete_client("Maria", "1234") == {:ok, "Maria com CPF: 1234 foi deletado"}
  end

  test "deve atualizar um atributo de um cliente" do
    Ecommerce.register_client(
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

    assert Ecommerce.update_client("Maria", "1234", "name", "Joao") ==
             {:ok, "Cliente Maria com CPF: 1234, atualizou: name: Maria, para: nome: Joao"}
  end
end
