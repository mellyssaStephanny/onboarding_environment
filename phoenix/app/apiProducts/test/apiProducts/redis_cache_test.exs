defmodule ApiProducts.RedisCacheTest do
  use ApiProductsWeb.ConnCase, async: false

  alias ApiProducts.Cache

  setup_all do
    %{
      key: "some_key",
      value: "some_value",
      invalid_key: "invalid_key"
    }
  end

  describe "Cache.set" do
    test "save data in cache", %{key: key, value: value} do
      assert Cache.set(key, value) == {:ok, "OK"}
    end
  end

  describe "Cache.get" do
    test "not get data in cache if key is invalid", %{invalid_key: invalid_key} do
      assert Cache.get(invalid_key) == {:error, "Key not found!"}
    end

    test "get data in cache if key is valid", %{key: key, value: value} do
      Cache.set(key, value)
      assert Cache.get(key) == {:ok, "some_value"}
    end
  end

  describe "Cache.delete" do
    test "delete data in cache if key is valid", %{key: key, value: value} do
      Cache.set(key, value)
      assert Cache.delete(key) == {:ok, 1}
      assert Cache.get(key) == {:error, "Key not found!"}
    end

    test "delete data in cache key is invalid", %{invalid_key: invalid_key} do
      assert Cache.delete(invalid_key) == {:ok, 0}
    end
  end
end
