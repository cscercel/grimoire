defmodule GrimoireWeb.ClubLiveTest do
  use GrimoireWeb.ConnCase

  import Phoenix.LiveViewTest
  import Grimoire.ClubsFixtures

  @create_attrs %{name: "some name", invite_token: "some invite_token", invite_token_expiry_dt: "2026-11-02T22:12:00Z"}
  @update_attrs %{name: "some updated name", invite_token: "some updated invite_token", invite_token_expiry_dt: "2026-11-03T22:12:00Z"}
  @invalid_attrs %{name: nil, invite_token: nil, invite_token_expiry_dt: nil}
  defp create_club(_) do
    club = club_fixture()

    %{club: club}
  end

  describe "Index" do
    setup [:create_club]

    test "lists all clubs", %{conn: conn, club: club} do
      {:ok, _index_live, html} = live(conn, ~p"/clubs")

      assert html =~ "Listing Clubs"
      assert html =~ club.name
    end

    test "saves new club", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/clubs")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Club")
               |> render_click()
               |> follow_redirect(conn, ~p"/clubs/new")

      assert render(form_live) =~ "New Club"

      assert form_live
             |> form("#club-form", club: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#club-form", club: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/clubs")

      html = render(index_live)
      assert html =~ "Club created successfully"
      assert html =~ "some name"
    end

    test "updates club in listing", %{conn: conn, club: club} do
      {:ok, index_live, _html} = live(conn, ~p"/clubs")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#clubs-#{club.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/clubs/#{club}/edit")

      assert render(form_live) =~ "Edit Club"

      assert form_live
             |> form("#club-form", club: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#club-form", club: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/clubs")

      html = render(index_live)
      assert html =~ "Club updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes club in listing", %{conn: conn, club: club} do
      {:ok, index_live, _html} = live(conn, ~p"/clubs")

      assert index_live |> element("#clubs-#{club.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#clubs-#{club.id}")
    end
  end

  describe "Show" do
    setup [:create_club]

    test "displays club", %{conn: conn, club: club} do
      {:ok, _show_live, html} = live(conn, ~p"/clubs/#{club}")

      assert html =~ "Show Club"
      assert html =~ club.name
    end

    test "updates club and returns to show", %{conn: conn, club: club} do
      {:ok, show_live, _html} = live(conn, ~p"/clubs/#{club}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/clubs/#{club}/edit?return_to=show")

      assert render(form_live) =~ "Edit Club"

      assert form_live
             |> form("#club-form", club: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#club-form", club: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/clubs/#{club}")

      html = render(show_live)
      assert html =~ "Club updated successfully"
      assert html =~ "some updated name"
    end
  end
end
