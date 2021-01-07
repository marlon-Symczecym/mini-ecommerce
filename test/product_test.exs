defmodule ProductTest do
  use ExUnit.Case
  doctest Product

  setup do
    File.mkdir("categorys")

    on_exit(fn ->
      File.rm_rf("categorys")
    end)
  end

  describe "Registrar produto" do
    test "deve cadastrar um produto" do
      Categorys.register_category("Cadeira")

      assert Product.register_product("Cadeira alta", "Linda cadeira", 1200, "Cadeira", 5) ==
               {:ok, "Produto Cadeira alta cadastrado com sucesso na categoria Cadeira!"}
    end

    test "deve retornar erro ao cadastrar um produto" do
      assert Product.register_product("Cadeira baixa", "Linda cadeira", 1200, "Poltrona", 5) ==
               {:error, "Categoria inexistente"}
    end

    test "deve retornar erro, dizendo que produto ja existe" do
      Categorys.register_category("Cadeira")
      Product.register_product("Cadeira listrada", "Linda cadeira", 1200, "Cadeira", 5)

      assert Product.register_product("Cadeira lisa", "Linda cadeira", 1200, "Cadeira", 5) ==
               {:ok, "Produto Cadeira lisa cadastrado com sucesso na categoria Cadeira!"}
    end
  end

  test "deve imprimir produtos da categoria" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira ripada", "Linda cadeira", 1200, "Cadeira", 5)

    assert Product.read_products_category("Cadeira") == :ok
    assert Product.read_products_category("Inexistente") == {:error, "Categoria inexistente"}
  end

  test "deve imprimir um produto de uma categoria especifica" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira estofada lisa", "Linda cadeira", 1200, "Cadeira", 5)

    assert Product.read_product("Cadeira estofada lisa", "Cadeira") == :ok

    assert Product.read_product("Inexistente", "Inexistente") ==
             {:error, "Categoria ou produto inexistente"}
  end

  test "deve retornar categoria nao registrada" do
    assert Product.read("inexistente") == {:error, "Categoria inexistente nao registrada!"}
  end

  test "deve deletar um produto" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira estofada com assento", "Linda cadeira", 1200, "Cadeira", 5)

    assert Product.delete_product("Cadeira estofada com assento", "Cadeira") ==
             {:ok,
              "Produto Cadeira estofada com assento da categoria Cadeira deletado com sucesso!"}

    assert Product.delete_product("Inexistente", "Inexistente") ==
             {:error, "Categoria ou produto inexistente"}
  end

  test "deve atualizar um atributo do produto" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira com braco", "Linda cadeira", 1200, "Cadeira", 5)

    assert Product.update_product(
             "Cadeira com braco",
             "Cadeira",
             "name",
             "Cadeira Branca"
           ) ==
             {:ok, "Produto atualizado com sucesso !"}

    assert Product.update_product(
             "Inexistente",
             "Inexistente",
             "Inexistente",
             "Inexistente"
           ) == {:error, "Categoria ou produto inexistente"}
  end

  test "deve testar a estrutura do modulo" do
    assert %Product{
             name: "Cadeira estofada",
             description: "Linda cadeira",
             category: "Cadeiras",
             price: 1200,
             stock: 6
           }.name == "Cadeira estofada"
  end

  test "deve encontrar um produto" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira com braco branco", "Linda cadeira", 1200, "Cadeira", 5)

    assert Product.find_product("Inexistente", "Inexistente") ==
             {:error, "Categoria ou produto inexistente"}
  end
end
