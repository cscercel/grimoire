defmodule Grimoire.Clubs.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "memberships" do
    field :role, Ecto.Enum, values: [:owner, :member], default: :member

    belongs_to :user, Grimoire.Accounts.User
    belongs_to :club, Grimoire.Clubs.Club

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> assoc_constraint(:user)
    |> assoc_constraint(:club)
    |> unique_constraint([:user_id, :club_id])
  end
end
