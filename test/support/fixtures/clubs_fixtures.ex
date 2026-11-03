defmodule Grimoire.ClubsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Grimoire.Clubs` context.
  """

  @doc """
  Generate a club.
  """
  def club_fixture(attrs \\ %{}) do
    {:ok, club} =
      attrs
      |> Enum.into(%{
        invite_token: "some invite_token",
        invite_token_expiry_dt: ~U[2026-11-02 22:12:00Z],
        name: "some name"
      })
      |> Grimoire.Clubs.create_club()

    club
  end
end
