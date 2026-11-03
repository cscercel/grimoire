defmodule Grimoire.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :name, :string
    field :invite_token, :string
    field :invite_expires_at, :utc_datetime
    field :calendar_token, :string

    has_many :memberships, Grimoire.Clubs.Membership

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 80)
  end
end
