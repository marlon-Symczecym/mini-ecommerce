defmodule PurchaseTest do
  use ExUnit.Case
  doctest Purchase

  @client_filepath "clients"
  @client_file "clients.txt"
  @client_path "#{@client_filepath}/#{@client_file}"

  setup do
    File.mkdir(@client_path)
    File.write(@client_path, :erlang.term_to_binary([]))
  end

  test "deve fazer uma compra" do
    Ecommerce.register_category("Cadeiras")
    Ecommerce.register_product("Cadeira alta com listras", "Linda cadeira", 1200, "Cadeiras", 5)

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

    assert Purchase.buy("Maria", "1234", "Cadeira alta com listras", "Cadeiras", 3) ==
             {:ok, "Cliente Maria acabou de comprar 3 Cadeira alta com listras !"}

    Purchase.buy("Maria", "1234", "Cadeira alta com listras", "Cadeiras", 1)
    Purchase.buy("Maria", "1234", "Cadeira alta com listras", "Cadeiras", 1)
    Purchase.buy("Maria", "1234", "Cadeira alta com listras", "Cadeiras", 1)

    assert Client.find_purchases_client("Maria", "1234") |> Enum.count() == 3
  end
end
