defmodule Categorys do
  @moduledoc """
  Modulo de Categorias onde é feito o registro e manutenção das categorias

  A função mais utilizada é `Categorys.register_category/1`
  """
  @categorys_path "categorys"

  @doc """
  Funcao faz o registro de uma nova categoria

  ## Parametro da funcao

  - category: nome da nova categoria

  ## Exemplo

      iex> Categorys.register_category("Teste")
      {:ok, "Categoria Teste registrado com sucesso!"}
  """
  def register_category(category) do
    cond do
      category_exists(category) == true ->
        {:error, "Categoria #{category} ja existe!"}

      category_exists(category) == false ->
        File.write("#{@categorys_path}/#{category}.txt", :erlang.term_to_binary([]))

        {:ok, "Categoria #{category} registrado com sucesso!"}
    end
  end

  @doc """
  Funcao renomeia uma categoria ja existente

  ## Parametros da funcao

  - old_category: nome da categoria que esta querendo renomear
  - new_category: novo nome para a categoria

  ## Informacoes adicionais

  - Se a categoria que sera renomeada nao existir, retorna uma tupla com erro e mensagem

  ## Exemplo

      iex> Categorys.rename_file_category("Teste", "TesteNovo")
      {:error, "Categoria Teste nao pode ser renomeado, pois nao existe!"}

  """
  def rename_file_category(old_category, new_category) do
    cond do
      category_exists(old_category) == true ->
        File.rename(
          "#{@categorys_path}/#{old_category}.txt",
          "#{@categorys_path}/#{new_category}.txt"
        )

        {:ok, "Categoria #{old_category} renomeado para #{new_category} com sucesso!"}

      category_exists(old_category) == false ->
        {:error, "Categoria #{old_category} nao pode ser renomeado, pois nao existe!"}
    end
  end

  @doc """
  Funcao deleta uma categoria

  ## Parametro da funcao

  - category: nome da categoria que ira deleta

  ## Informacoes adicionais

  - Se a categoria que sera renomeada nao existir, retorna uma tupla com erro e mensagem

  ## Exemplo

      iex> Categorys.delete_category("Teste")
      {:error, "Categoria Teste nao pode ser deletada, pois nao existe!"}
  """
  def delete_category(category) do
    cond do
      category_exists(category) == true ->
        File.rm("#{@categorys_path}/#{category}.txt")
        {:ok, "Categoria #{category} deletado com sucesso!"}

      category_exists(category) == false ->
        {:error, "Categoria #{category} nao pode ser deletada, pois nao existe!"}
    end
  end

  @doc """
  Funcao que verifica se uma categoria existe

  ## Parametro da funcao

  - category: nome da categoria que sera verificada


  ## Exemplo

      iex> Categorys.category_exists("Teste")
      false
  """
  def category_exists(category) do
    File.exists?("#{@categorys_path}/#{category}.txt")
  end

  @doc """
  Funcao que mostra informacoes das categorias
  """
  def show_info_categorys do
    {:ok, categorys} = File.ls("#{@categorys_path}")

    IO.puts("----------------------------------")
    IO.puts("Numero de categorias\ncadastradas: #{count_categorys()}")
    IO.puts("----------------------------------")

    categorys
    |> Enum.map(&clean_text/1)
  end

  defp count_categorys do
    {:ok, categorys} = File.ls("#{@categorys_path}")

    categorys
    |> Enum.count()
  end

  defp clean_text(text) do
    text
    |> String.trim(".txt")
    |> echo()
  end

  defp echo(category) do
    IO.puts("Nome: #{category}")
    IO.puts("----------------------------------")
  end
end
