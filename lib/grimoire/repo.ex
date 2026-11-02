defmodule Grimoire.Repo do
  use Ecto.Repo,
    otp_app: :grimoire,
    adapter: Ecto.Adapters.SQLite3
end
