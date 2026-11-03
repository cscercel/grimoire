defmodule Grimoire.Clubs.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "memberships" do
    field :role, Ecto.Enum, values: [:owner, :member]
    field :club_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(membership, attrs, user_scope) do
    membership
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> put_change(:user_id, user_scope.user.id)
  end
end
