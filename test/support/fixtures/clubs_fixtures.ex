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
        name: "some name"
      })
      |> Grimoire.Clubs.create_club()

    club
  end
end
