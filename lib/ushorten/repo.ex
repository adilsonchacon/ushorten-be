defmodule Ushorten.Repo do
  use Ecto.Repo,
    otp_app: :ushorten,
    adapter: Ecto.Adapters.Postgres
end
