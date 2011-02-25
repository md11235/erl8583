%% Author: carl
%% Created: 06 Feb 2011
%% Description: TODO: Add description to xml_marshaller
-module(xml_marshaller).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([marshal/1]).

%%
%% API Functions
%%
marshal(IsoMsg) ->
	"<isomsg" ++ 
		encode_attributes(iso8583_message:get_attributes(IsoMsg)) ++ 
		">" ++ 
		marshal_fields(iso8583_message:to_list(IsoMsg), []) ++ 
		"</isomsg>\n".


%%
%% Local Functions
%%
marshal_fields([], Result) ->
	Result;
marshal_fields([{K, V}|Tail], Result) when is_list(V)  ->
	Id = integer_to_list(K),
	marshal_fields(Tail, "<field id=\"" ++ Id ++ "\" value=\"" ++ V ++ "\" />" ++ Result);
marshal_fields([{K, V}|Tail], Result) when is_binary(V) ->
	Id = integer_to_list(K),
	marshal_fields(Tail, "<field id=\"" ++ Id ++ "\" value=\"" ++ 
						convert:binary_to_ascii_hex(V) ++ 
						"\" type=\"binary\" />" ++ Result);	
marshal_fields([{K, V}|Tail], Result) ->
	Id = integer_to_list(K),
	marshal_fields(Tail, "<isomsg id=\"" ++ Id ++ "\"" ++
						encode_attributes(iso8583_message:get_attributes(V)) ++ 
						">" ++ 
						marshal_fields(iso8583_message:to_list(V), "") ++ 
						"</isomsg>" ++ 
						Result).
	
encode_attributes(List) ->
	encode_attributes(List, "").

encode_attributes([], Result) ->
	Result;
encode_attributes([{Key, Value} | Tail], Result) ->
	encode_attributes(Tail, " " ++ Key ++ "=\"" ++ Value ++ "\"" ++  Result).
