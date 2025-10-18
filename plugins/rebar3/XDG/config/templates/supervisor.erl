%%% --------------------------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (c) {{current_year}}, {{author_name}}
%%% @doc
%%% @end
%%% --------------------------------------------------------------------------------------

-module({{name}}_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%% --------------------------------------------------------------------------------------
%% Infrastructure
%% --------------------------------------------------------------------------------------

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% --------------------------------------------------------------------------------------
%% Supervisor callbacks
%% --------------------------------------------------------------------------------------

init([]) ->
    Flags = #{strategy => one_for_all,
              intensity => 0,
              period => 1},
    Specs = [],
    {ok, {Flags, Specs}}.

%% --------------------------------------------------------------------------------------
%% Internals
%% --------------------------------------------------------------------------------------

%% child_spec() -> 
%%     #{id => child_id(),       % mandatory
%%       start => mfargs(),      % mandatory
%%       restart => restart(),   % optional, permanent | temporary | transient
%%       shutdown => shutdown(), % optional, 5000?
%%       type => worker(),       % optional, or supervisor
%%       modules => modules()}   % optional
