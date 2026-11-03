defmodule Grimoire.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs) do
      add :name, :string, null: false
      add :invite_token, :string, null: false
      add :invite_expires_at, :utc_datetime
      add :calendar_token, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:clubs, [:invite_token])
    create unique_index(:clubs, [:calendar_token])
  end
end
