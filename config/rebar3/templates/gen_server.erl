%%% --------------------------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (c) {{current_year}}, {{author_name}}
%%% @doc
%%% @end
%%% --------------------------------------------------------------------------------------

-module({{name}}).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-ifdef(TEST).
-compile(nowarn_export_all).
-compile(export_all).
-endif.

-record(state, {
         }).

%% --------------------------------------------------------------------------------------
%% API
%% --------------------------------------------------------------------------------------

%% --------------------------------------------------------------------------------------
%% Infrastructure
%% --------------------------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------------------------
%% gen_server callbacks
%% --------------------------------------------------------------------------------------

init([]) ->
    {ok, #state{}}.

handle_call(_Msg, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------------------------
%% Internals
%% --------------------------------------------------------------------------------------
