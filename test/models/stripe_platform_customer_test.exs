defmodule CodeCorps.StripePlatformCustomerTest do
  use CodeCorps.ModelCase

  alias CodeCorps.StripePlatformCustomer

  @valid_attrs %{
    id_from_stripe: "abc123"
  }

  @invalid_attrs %{}

  describe "create_changeset/2" do
    test "reports as valid when attributes are valid" do
      user_id = insert(:user).id

      changes = Map.merge(@valid_attrs, %{user_id: user_id})
      changeset = StripePlatformCustomer.create_changeset(%StripePlatformCustomer{}, changes)
      assert changeset.valid?
    end

    test "reports as invalid when attributes are invalid" do
      changeset = StripePlatformCustomer.create_changeset(%StripePlatformCustomer{}, @invalid_attrs)
      refute changeset.valid?

      assert changeset.errors[:id_from_stripe] == {"can't be blank", []}
      assert changeset.errors[:user_id] == {"can't be blank", []}
    end

    test "ensures associations link to records that exist" do
      attrs =  @valid_attrs |> Map.merge(%{user_id: -1})

      {result, changeset} =
        %StripePlatformCustomer{}
        |> StripePlatformCustomer.create_changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      assert changeset.errors[:user] == {"does not exist", []}
    end
  end
end
