defmodule Grimoire.Clubs do
  @moduledoc """
  The Clubs context.
  """

  import Ecto.Query, warn: false
  alias Grimoire.Repo

  alias Grimoire.Clubs.{Club, Membership}

  @doc """
  Returns the list of clubs.

  ## Examples

      iex> list_clubs()
      [%Club{}, ...]

  """
  def list_clubs(%{user: user}) do
    Repo.all(
      from c in Club,
        join: m in Membership,
        on: m.club_id == c.id,
        where: m.user_id == ^user.id,
        order_by: [asc, c.name]
    )
  end

  @doc """
  Gets a single club.

  Raises `Ecto.NoResultsError` if the Club does not exist.

  ## Examples

      iex> get_club!(123)
      %Club{}

      iex> get_club!(456)
      ** (Ecto.NoResultsError)

  """
  def get_club!(%{user: user}, id) do
    Repo.one!(
      from c in Club,
        join: m in Membership,
        on: m.club_id == c.id,
        where: c.id == ^id and m.user_id == ^user.id
    )
  end

  @doc """
  Creates a club.

  ## Examples

      iex> create_club(%{field: value})
      {:ok, %Club{}}

      iex> create_club(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_club(%{user: user}, attrs) do
    club =
      %Club{
        invite_token: generate_token(),
        invite_expires_at: invite_expiry(),
        calendar_token: generate_token()
      }

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:club, Club.changeset(club, attrs))
    |> Ecto.Multi.insert(:membership, fn %{club: club} ->
      %Membership{user_id: user.id, club_id: club.id}
      |> Membership.changeset(%{role: :owner})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{club: club}} -> {:ok, club}
      {:error, :club, changeset, _changes} -> {:error, changeset}
      {:error, :membership, changeset, _changes} -> {:error, changeset}
    end
  end

  @doc """
  Updates a club.

  ## Examples

      iex> update_club(club, %{field: new_value})
      {:ok, %Club{}}

      iex> update_club(club, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_club(%{user: user}, %Club{} = club, attrs) do
    with :ok <- authorize_owner(user, club) do
      club
      |> Club.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a club.

  ## Examples

      iex> delete_club(club)
      {:ok, %Club{}}

      iex> delete_club(club)
      {:error, %Ecto.Changeset{}}

  """
  def delete_club(%{user: user}, %Club{} = club) do
    with :ok <- authorize_owner(user, club) do
      Repo.delete(club)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking club changes.

  ## Examples

      iex> change_club(club)
      %Ecto.Changeset{data: %Club{}}

  """
  def change_club(%Club{} = club, attrs \\ %{}) do
    Club.changeset(club, attrs)
  end

  defp generate_token do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
  end

  defp invite_expiry do
    DateTime.utc_now() |> DateTime.add(7, :day) |> DateTime.truncate(:second)
  end

  defp authorize_owner(user, club) do
    owner? = Repo.exists?(
      from m in Membership,
      where: m.user_id == ^user.id and m.club_id == ^club.id and m.role == ^:owner
    )

    if owner?, do: :ok else: {:error, :unauthorized}
  end
end
