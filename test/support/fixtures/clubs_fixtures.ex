defmodule Grimoire.ClubsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Grimoire.Clubs` context.
  """

  @doc """
  Generate a club.
  """
  def club_fixture(scope, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{name: "some name"})

    {:ok, club} = Grimoire.Clubs.create_club(scope, attrs)

    club
  end
end
