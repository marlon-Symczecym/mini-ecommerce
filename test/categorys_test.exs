defmodule CategorysTest do
  use ExUnit.Case
  doctest Categorys

  setup do
    File.mkdir("categorys")

    on_exit(fn ->
      File.rm_rf("categorys")
    end)
  end

  describe "Registrar Categoria" do
    test "deve registrar uma categoria" do
      assert Categorys.register_category("Poltronas") ==
               {:ok, "Categoria Poltronas registrado com sucesso!"}
    end

    test "deve retornar categoria existente" do
      Categorys.register_category("Teste")

      assert Categorys.register_category("Teste") ==
               {:error, "Categoria Teste ja existe!"}
    end
  end

  describe "Renomear Categoria" do
    test "deve renomear uma categoria" do
      Categorys.register_category("Teste")

      assert Categorys.rename_file_category("Teste", "TesteNovo") ==
               {:ok, "Categoria Teste renomeado para TesteNovo com sucesso!"}
    end

    test "deve retornar categoria nao existente" do
      assert Categorys.rename_file_category("Teste", "TesteNovo") ==
               {:error, "Categoria Teste nao pode ser renomeado, pois nao existe!"}
    end
  end

  describe "Deletar Categoria" do
    test "deve deletar uma categoria existente" do
      Categorys.register_category("Teste")

      assert Categorys.delete_category("Teste") == {:ok, "Categoria Teste deletado com sucesso!"}
    end

    test "deve retornar que categoria nao existe" do
      assert Categorys.delete_category("Teste") ==
               {:error, "Categoria Teste nao pode ser deletada, pois nao existe!"}
    end
  end

  test "deve mostrar informacoes das categorias" do
    Categorys.register_category("Teste")
    Categorys.register_category("Teste2")
    Categorys.register_category("Teste3")

    assert Categorys.show_info_categorys() == [:ok, :ok, :ok]
  end
end
