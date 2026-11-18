defmodule GrimoireWeb.ClubLiveTest do
  use GrimoireWeb.ConnCase

  import Phoenix.LiveViewTest
  import Grimoire.AccountsFixtures
  import Grimoire.ClubsFixtures

  alias Grimoire.Repo
  alias Grimoire.Clubs.Membership

  setup :register_and_log_in_user

  test "lists only my clubs", %{conn: conn, scope: scope} do
    club_fixture(scope, %{name: "Mine"})
    club_fixture(user_scope_fixture(), %{name: "Theirs"})

    {:ok, _lv, html} = live(conn, ~p"/clubs")

    assert html =~ "Mine"
    refute html =~ "Theirs"
  end

  test "creates a club", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/clubs/new")

    {:ok, _lv, html} =
      lv
      |> form("#club-form", club: %{name: "Fresh"})
      |> render_submit()
      |> follow_redirect(conn, ~p"/clubs")

    assert html =~ "Club created successfully"
    assert html =~ "Fresh"
  end

  test "non-members can't open another club's page", %{conn: conn} do
    club = club_fixture(user_scope_fixture())

    assert_raise Ecto.NoResultsError, fn -> live(conn, ~p"/clubs/#{club}") end
  end

  test "regular members are sent away from the edit form", %{conn: conn, scope: scope} do
    club = club_fixture(user_scope_fixture())
    Repo.insert!(%Membership{user_id: scope.user.id, club_id: club.id, role: :member})

    assert {:error, {kind, %{to: "/clubs"}}} = live(conn, ~p"/clubs/#{club}/edit")
    assert kind in [:redirect, :live_redirect]
  end
end
