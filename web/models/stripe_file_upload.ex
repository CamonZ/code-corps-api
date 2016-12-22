defmodule CodeCorps.StripeFileUpload do
  use CodeCorps.Web, :model

  schema "stripe_file_uploads" do
    field :created, Timex.Ecto.DateTime
    field :id_from_stripe, :string, null: false
    field :purpose, :string
    field :size, :integer
    field :type, :string
    field :url, :string

    belongs_to :stripe_connect_account, CodeCorps.StripeConnectAccount

    timestamps()
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:created, :id_from_stripe, :purpose, :size, :type, :url, :stripe_connect_account_id])
    |> validate_required([:id_from_stripe])
    |> assoc_constraint(:stripe_connect_account)
  end
end
