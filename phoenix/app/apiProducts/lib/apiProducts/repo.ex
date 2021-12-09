defmodule ApiProducts.Repo do
  use Ecto.Repo,
    otp_app: :apiProducts,
    adapter: Ecto.Adapters.Postgres
end
