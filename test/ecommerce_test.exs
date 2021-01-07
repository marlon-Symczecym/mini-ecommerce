defmodule EcommerceTest do
  use ExUnit.Case
  doctest Ecommerce

  setup do
    File.mkdir("categorys")

    on_exit(fn ->
      File.rm_rf("categorys")
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
end
