defmodule ApiProductsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ApiProductsWeb, :controller
  alias ApiProducts.Catalog.Product
  
  def call(conn, {:ok, %Product{} = product}) do 
    render(conn, "show.json", product: product)
  end 

  def call(conn, {conn, :no_content}) do 
    render(conn, :no_content, "")
  end 

  def call(conn, {:error, _any}) do
    render(conn, :bad_request, "")
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiProductsWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn 
    |> put_status(:not_found)
    |> put_view(ApiProductsWeb.ErrorView)
    |> render(:"404")
    |> halt()
  end
end