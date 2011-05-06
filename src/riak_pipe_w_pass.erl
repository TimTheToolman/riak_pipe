%% -------------------------------------------------------------------
%%
%% Copyright (c) 2011 Basho Technologies, Inc.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(riak_pipe_w_pass).
-behaviour(riak_pipe_vnode_worker).

-export([init/2,
         process/2,
         done/1]).

-include("riak_pipe_log.hrl").

-record(state, {p, fd}).

init(Partition, FittingDetails) ->
    {ok, #state{p=Partition, fd=FittingDetails}}.

process(Input, #state{p=Partition, fd=FittingDetails}=State) ->
    ?T(FittingDetails, [], {processing, Input}),
    riak_pipe_vnode_worker:send_output(Input, Partition, FittingDetails),
    ?T(FittingDetails, [], {processed, Input}),
    {ok, State}.

done(_State) ->
    ok.