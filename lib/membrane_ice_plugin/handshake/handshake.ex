defmodule Membrane.ICE.Handshake do
  @moduledoc """
  Behaviour that specifies functions that have to be implemented in order to perform handshake
  after establishing ICE connection.

  One instance of this module is responsible for performing handshake only for one component.
  """

  @type t :: module

  @typedoc """
  It is any type that user want it to be passed to other functions of this behaviour.
  """
  @type state :: term()

  @typedoc """
  Notification sent to pipeline after executing `init/1` function on handshake module
  """
  @type init_notification ::
          {:handshake_init_data, component_id :: non_neg_integer(), init_data :: any()}

  @doc """
  Called only once at Sink/Source preparation.

  `opts` - options specified in `handshake_opts` option in Sink/Source
  `init_data` - any data that will be fired as a notification to pipeline. Notification
  will be of type `t:init_notification/0`
  `state` - state that will be passed to other functions

  Returning by a peer `:finished` will mark handshake as finished and none of the remaining
  functions will be invoked for this peer.
  """
  @callback init(opts :: list()) ::
              {:ok, init_data :: any(), state()}
              | {:finished, init_data :: any()}

  @doc """
  Called only once when component changes state to READY i.e. it is able to receive and send data.

  It is a good place to start your handshake.
  """
  @callback connection_ready(state :: state()) :: :ok

  @doc """
  Called each time remote data arrives.
  """
  @callback process(state :: state(), data :: binary()) :: :ok

  @doc """
  Determines if given `data` should be treated as handshake packet and passed to `recv_from_peer/2`.
  """
  @callback is_handshake_packet(state :: state(), data :: binary()) :: boolean()
end
