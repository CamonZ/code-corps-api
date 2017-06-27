defmodule CodeCorps.GitHub.Events.Installation do
  @moduledoc """
  In charge of dealing with "Installation" GitHub Webhook events
  """

  alias CodeCorps.GithubEvent

  @doc """
  Handles an "Installation" GitHub Webhook event

  The general idea is
  - marked the passed in event as "processing"
  - do the work
  - marked the passed in event as "processed" or "errored"
  """
  def handle(%GithubEvent{}, %{}), do: :not_fully_implemented
end
