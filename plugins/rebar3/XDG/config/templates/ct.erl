%%% --------------------------------------------------------------------------------------
%%% @author {{author_name}} <{{author_email}}>
%%% @copyright (c) {{current_year}}, {{author_name}}
%%% @doc
%%% @end
%%% --------------------------------------------------------------------------------------

-module({{name}}_SUITE).

-export([all/0, groups/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([init_per_group/2, end_per_group/2]).
-export([init_per_testcase/2, end_per_testcase/2]).

%% --------------------------------------------------------------------------------------
%% CT Callbacks
%% --------------------------------------------------------------------------------------

all() ->
    ok.

groups() ->
    ok.

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_Group, Config) ->
    Config.

end_per_group(_Group, _Config) ->
    ok.

init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(_TestCase, _Config) ->
    ok.

%% --------------------------------------------------------------------------------------
%% Tests
%% --------------------------------------------------------------------------------------

%% --------------------------------------------------------------------------------------
%% Internals
%% --------------------------------------------------------------------------------------
