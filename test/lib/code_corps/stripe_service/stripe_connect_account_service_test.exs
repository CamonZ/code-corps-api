defmodule CodeCorps.StripeService.StripeConnectAccountServiceTest do
  use ExUnit.Case, async: true

  use CodeCorps.ModelCase

  alias CodeCorps.{StripeConnectAccount}
  alias CodeCorps.StripeService.StripeConnectAccountService

  describe "create" do
    test "creates a StripeConnectAccount" do
      organization = insert(:organization)

      attributes = %{"country" => "US", "organization_id" => organization.id}

      {:ok, %StripeConnectAccount{} = connect_account} =
        StripeConnectAccountService.create(attributes)

      assert connect_account.country == "US"
      assert connect_account.organization_id == organization.id
      assert connect_account.managed == true
    end
  end

  describe "add_external_account/2" do
    test "assigns the external_account property to the record" do
      account = insert(:stripe_connect_account)

      {:ok, %StripeConnectAccount{} = updated_account} =
        StripeConnectAccountService.add_external_account(account, "ba_test123")
      assert updated_account.external_account == "ba_test123"
    end
  end
end
