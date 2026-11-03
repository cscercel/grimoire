defmodule Grimoire.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs) do
      add :name, :string
      add :invite_token, :string
      add :invite_token_expiry_dt, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
