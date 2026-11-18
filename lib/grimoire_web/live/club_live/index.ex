defmodule GrimoireWeb.ClubLive.Index do
  use GrimoireWeb, :live_view

  alias Grimoire.Clubs

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Clubs
        <:actions>
          <.button variant="primary" navigate={~p"/clubs/new"}>
            <.icon name="hero-plus" /> New Club
          </.button>
        </:actions>
      </.header>

      <.table
        id="clubs"
        rows={@streams.clubs}
        row_click={fn {_id, club} -> JS.navigate(~p"/clubs/#{club}") end}
      >
        <:col :let={{_id, club}} label="Name">{club.name}</:col>
        <:action :let={{_id, club}}>
          <div class="sr-only">
            <.link navigate={~p"/clubs/#{club}"}>Show</.link>
          </div>
          <.link :if={club.id in @owned_ids} navigate={~p"/clubs/#{club}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, club}}>
          <.link
            :if={club.id in @owned_ids}
            phx-click={JS.push("delete", value: %{id: club.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Clubs")
     |> assign(:owned_ids, Clubs.owned_club_ids(socket.assigns.current_scope))
     |> stream(:clubs, list_clubs(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    scope = socket.assigns.current_scope
    club = Clubs.get_club!(scope, id)

    case Clubs.delete_club(scope, club) do
      {:ok, _club} ->
        {:noreply, stream_delete(socket, :clubs, club)}

      {:error, :unauthorized} ->
        {:noreply, put_flash(socket, :error, "Only a club owner can delete the club")}
    end
  end

  defp list_clubs(scope) do
    Clubs.list_clubs(scope)
  end
end
