defmodule FirebaseAdminEx.Messaging.Message do
  @moduledoc """
  This module is responsible for representing the
  attributes of FirebaseAdminEx.Message.
  """

  alias __MODULE__
  alias FirebaseAdminEx.Messaging.WebMessage.Config, as: WebMessageConfig
  alias FirebaseAdminEx.Messaging.AndroidMessage.Config, as: AndroidMessageConfig
  alias FirebaseAdminEx.Messaging.APNSMessage.Config, as: APNSMessageConfig

  @keys [
    data: %{},
    notification: %{},
    webpush: %WebMessageConfig{},
    android: %AndroidMessageConfig{},
    apns: %APNSMessageConfig{},
    token: ""
  ]

  @type t :: %__MODULE__{
          data: map(),
          notification: map(),
          webpush: struct(),
          android: struct(),
          apns: struct(),
          token: String.t()
        }

  defstruct @keys

  # Public API
  def new([data: data, token: token, webpush: webpush] = attributes) do
    %Message{
      data: data || %{},
      notification: Keyword.get(attributes, :notification, %{}),
      webpush: webpush,
      token: token
    }
  end

  def new([data: data, token: token, android: android] = attributes) do
    %Message{
      data: data || %{},
      notification: Keyword.get(attributes, :notification, %{}),
      android: android,
      token: token
    }
  end

  def new([data: data, token: token, apns: apns] = attributes) do
    %Message{
      data: data || %{},
      notification: Keyword.get(attributes, :notification, %{}),
      apns: apns,
      token: token
    }
  end

  def new([data: data, token: token] = attributes) do
    %Message{
      data: data || %{},
      notification: Keyword.get(attributes, :notification, %{}),
      token: token
    }
  end

  def validate(%Message{data: _, token: nil}), do: {:error, "[Message] token is missing"}

  def validate(%Message{data: _, token: _, webpush: nil, android: nil, apns: nil} = message),
    do: {:ok, message}

  def validate(%Message{data: _, token: _, webpush: web_message_config} = message) do
    case WebMessageConfig.validate(web_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(%Message{data: _, token: _, android: android_message_config} = message) do
    case AndroidMessageConfig.validate(android_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(%Message{data: _, token: _, apns: apns_message_config} = message) do
    case APNSMessageConfig.validate(apns_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[Message] Invalid payload"}
end