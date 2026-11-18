defmodule Grimoire.ClubsTest do
  use Grimoire.DataCase

  import Grimoire.AccountsFixtures

  alias Grimoire.Clubs
  alias Grimoire.Clubs.{Club, Membership}

  setup do
    owner = user_scope_fixture()
    other = user_scope_fixture()
    {:ok, club} = Clubs.create_club(owner, %{name: "Night Readers"})
    %{owner: owner, other: other, club: club}
  end

  test "create_club makes the creator an owner", %{owner: owner, club: club} do
    membership = Repo.get_by!(Membership, club_id: club.id, user_id: owner.user.id)
    assert membership.role == :owner
  end

  test "create_club ignores tokens supplied by the caller" do
    scope = user_scope_fixture()
    {:ok, club} = Clubs.create_club(scope, %{name: "X", invite_token: "hacked"})

    refute club.invite_token == "hacked"
    assert club.invite_token && club.calendar_token
  end

  test "create_club with invalid data creates nothing" do
    scope = user_scope_fixture()
    before = Repo.aggregate(Club, :count)

    assert {:error, %Ecto.Changeset{}} = Clubs.create_club(scope, %{name: ""})
    assert Repo.aggregate(Club, :count) == before
    assert Repo.aggregate(Membership, :count) == before
  end

  test "list_clubs only returns the user's clubs", %{owner: owner, other: other, club: club} do
    assert [%Club{id: id}] = Clubs.list_clubs(owner)
    assert id == club.id
    assert Clubs.list_clubs(other) == []
  end

  test "get_club! raises for non-members", %{other: other, club: club} do
    assert_raise Ecto.NoResultsError, fn -> Clubs.get_club!(other, club.id) end
  end

  test "regular members cannot update or delete", %{other: other, club: club} do
    Repo.insert!(%Membership{user_id: other.user.id, club_id: club.id, role: :member})

    assert {:error, :unauthorized} = Clubs.update_club(other, club, %{name: "Hacked"})
    assert {:error, :unauthorized} = Clubs.delete_club(other, club)
    assert Repo.get!(Club, club.id).name == "Night Readers"
  end

  test "owners can update and delete", %{owner: owner, club: club} do
    assert {:ok, %Club{name: "New Name"}} = Clubs.update_club(owner, club, %{name: "New Name"})
    assert {:ok, _} = Clubs.delete_club(owner, club)
    assert Repo.get(Club, club.id) == nil
  end
end
