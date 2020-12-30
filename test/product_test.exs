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

      assert Product.register_product("Cadeira alta", "Linda cadeira", "1200", "Cadeira", 5) ==
               {:ok, "Produto Cadeira alta cadastrado com sucesso na categoria Cadeira!"}
    end

    test "deve retornar erro ao cadastrar um produto" do
      assert Product.register_product("Cadeira alta", "Linda cadeira", "1200", "Poltrona", 5) ==
               {:error, "Categoria inesistente"}
    end
  end

  test "deve imprimir produtos da categoria" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira alta", "Linda cadeira", "1200", "Cadeira", 5)

    assert Product.read_products_category("Cadeira") == :ok
  end

  test "deve imprimir um produto de uma categoria especifica" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira estofada", "Linda cadeira", "1200", "Cadeira", 5)

    assert Product.read_product("Cadeira estofada", "Cadeira") == :ok
  end

  test "deve retornar categoria nao registrada" do
    assert Product.read("Inesistente") == {:error, "Categoria Inesistente nao registrada!"}
  end

  test "deve deletar um produto" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira estofada", "Linda cadeira", "1200", "Cadeira", 5)

    assert Product.delete_product("Cadeira estofada", "Cadeira") ==
             {:ok, "Produto Cadeira estofada da categoria Cadeira deletado com sucesso!"}
  end

  test "deve atualizar um atributo do produto" do
    Categorys.register_category("Cadeira")
    Product.register_product("Cadeira estofada", "Linda cadeira", "1200", "Cadeira", 5)

    assert Product.update_product("Cadeira estofada", "Cadeira Branca", "Cadeira", "name") ==
             {:ok,
              "Produto Cadeira estofada com atualicação no atributo name agora ta com: Cadeira Branca"}
  end

  test "deve testar a estrutura do modulo" do
    assert %Product{
             name: "Cadeira estofada",
             description: "Linda cadeira",
             category: "Cadeiras",
             price: "1200",
             stock: 6
           }.name == "Cadeira estofada"
  end
end
