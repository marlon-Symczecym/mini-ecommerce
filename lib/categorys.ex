defmodule Categorys do
  @categorys_path "categorys"

  def register_category(category) do
    case category_exists(category) do
      false ->
        File.write("#{@categorys_path}/#{category}.txt", :erlang.term_to_binary([]))

        {:ok, "Categoria #{category} registrado com sucesso!"}

      true ->
        {:error, "Categoria #{category} ja existe!"}
    end
  end

  def rename_file_category(old_category, new_category) do
    case category_exists(old_category) do
      false ->
        {:error, "Categoria #{old_category} nao pode ser renomeado, pois nao existe!"}

      true ->
        File.rename(
          "#{@categorys_path}/#{old_category}.txt",
          "#{@categorys_path}/#{new_category}.txt"
        )

        {:ok, "Categoria #{old_category} renomeado para #{new_category} com sucesso!"}
    end
  end

  def delete_category(category) do
    case category_exists(category) do
      false ->
        {:error, "Categoria #{category} nao pode ser deletada, pois nao existe!"}

      true ->
        File.rm("#{@categorys_path}/#{category}.txt")
        {:ok, "Categoria #{category} deletado com sucesso!"}
    end
  end

  def category_exists(category) do
    File.exists?("#{@categorys_path}/#{category}.txt")
  end

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
