defmodule EcommerceTest do
  use ExUnit.Case
  doctest Ecommerce

  test "greets the world" do
    assert Ecommerce.hello() == :world
  end
end
