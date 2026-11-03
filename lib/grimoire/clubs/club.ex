defmodule Grimoire.Clubs.Club do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clubs" do
    field :name, :string
    field :invite_token, :string
    field :invite_token_expiry_dt, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(club, attrs) do
    club
    |> cast(attrs, [:name, :invite_token, :invite_token_expiry_dt])
    |> validate_required([:name, :invite_token, :invite_token_expiry_dt])
  end
end
