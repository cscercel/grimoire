defmodule Grimoire.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :role, :string, null: false, default: "member"
      add :club_id, references(:clubs, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:memberships, [:user_id, :club_id])
    create index(:memberships, [:club_id])
  end
end
