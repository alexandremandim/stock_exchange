%% -*- coding: utf-8 -*-
%% Automatically generated, do not edit
%% Generated by gpb_compile version 4.1.1
-module(order).

-export([encode_msg/1, encode_msg/2]).
-export([decode_msg/2, decode_msg/3]).
-export([merge_msgs/2, merge_msgs/3]).
-export([verify_msg/1, verify_msg/2]).
-export([get_msg_defs/0]).
-export([get_msg_names/0]).
-export([get_group_names/0]).
-export([get_msg_or_group_names/0]).
-export([get_enum_names/0]).
-export([find_msg_def/1, fetch_msg_def/1]).
-export([find_enum_def/1, fetch_enum_def/1]).
-export([enum_symbol_by_value/2, enum_value_by_symbol/2]).
-export([enum_symbol_by_value_OrderRequestType/1, enum_value_by_symbol_OrderRequestType/1]).
-export([enum_symbol_by_value_OrderReplyType/1, enum_value_by_symbol_OrderReplyType/1]).
-export([get_service_names/0]).
-export([get_service_def/1]).
-export([get_rpc_names/1]).
-export([find_rpc_def/2, fetch_rpc_def/2]).
-export([get_package_name/0]).
-export([gpb_version_as_string/0, gpb_version_as_list/0]).

-include("order.hrl").
-include("gpb.hrl").

%% enumerated types
-type 'OrderRequestType'() :: 'BUY' | 'SELL'.
-type 'OrderReplyType'() :: 'OK' | 'NOT_OK' | 'INVALID_COMPANY' | 'NOT_LOGGED_IN'.
-export_type(['OrderRequestType'/0, 'OrderReplyType'/0]).

%% message types
-type 'OrderRequestData'() :: #'OrderRequestData'{}.
-type 'OrderReplyData'() :: #'OrderReplyData'{}.
-export_type(['OrderRequestData'/0, 'OrderReplyData'/0]).

-spec encode_msg(#'OrderRequestData'{} | #'OrderReplyData'{}) -> binary().
encode_msg(Msg) -> encode_msg(Msg, []).


-spec encode_msg(#'OrderRequestData'{} | #'OrderReplyData'{}, list()) -> binary().
encode_msg(Msg, Opts) ->
    case proplists:get_bool(verify, Opts) of
      true -> verify_msg(Msg, Opts);
      false -> ok
    end,
    TrUserData = proplists:get_value(user_data, Opts),
    case Msg of
      #'OrderRequestData'{} ->
	  e_msg_OrderRequestData(Msg, TrUserData);
      #'OrderReplyData'{} ->
	  e_msg_OrderReplyData(Msg, TrUserData)
    end.



e_msg_OrderRequestData(Msg, TrUserData) ->
    e_msg_OrderRequestData(Msg, <<>>, TrUserData).


e_msg_OrderRequestData(#'OrderRequestData'{order_type =
					       F1,
					   company = F2, qtd = F3, price = F4,
					   username = F5},
		       Bin, TrUserData) ->
    B1 = if F1 == undefined -> Bin;
	    true ->
		begin
		  TrF1 = id(F1, TrUserData),
		  if TrF1 =:= 'BUY' -> Bin;
		     true -> e_enum_OrderRequestType(TrF1, <<Bin/binary, 8>>)
		  end
		end
	 end,
    B2 = if F2 == undefined -> B1;
	    true ->
		begin
		  TrF2 = id(F2, TrUserData),
		  case is_empty_string(TrF2) of
		    true -> B1;
		    false -> e_type_string(TrF2, <<B1/binary, 18>>)
		  end
		end
	 end,
    B3 = if F3 == undefined -> B2;
	    true ->
		begin
		  TrF3 = id(F3, TrUserData),
		  if TrF3 =:= 0 -> B2;
		     true -> e_type_int32(TrF3, <<B2/binary, 24>>)
		  end
		end
	 end,
    B4 = if F4 == undefined -> B3;
	    true ->
		begin
		  TrF4 = id(F4, TrUserData),
		  if TrF4 =:= 0 -> B3;
		     true -> e_type_int32(TrF4, <<B3/binary, 32>>)
		  end
		end
	 end,
    if F5 == undefined -> B4;
       true ->
	   begin
	     TrF5 = id(F5, TrUserData),
	     case is_empty_string(TrF5) of
	       true -> B4;
	       false -> e_type_string(TrF5, <<B4/binary, 42>>)
	     end
	   end
    end.

e_msg_OrderReplyData(Msg, TrUserData) ->
    e_msg_OrderReplyData(Msg, <<>>, TrUserData).


e_msg_OrderReplyData(#'OrderReplyData'{reply_type = F1},
		     Bin, TrUserData) ->
    if F1 == undefined -> Bin;
       true ->
	   begin
	     TrF1 = id(F1, TrUserData),
	     if TrF1 =:= 'OK' -> Bin;
		true -> e_enum_OrderReplyType(TrF1, <<Bin/binary, 8>>)
	     end
	   end
    end.

e_enum_OrderRequestType('BUY', Bin) ->
    <<Bin/binary, 0>>;
e_enum_OrderRequestType('SELL', Bin) ->
    <<Bin/binary, 1>>;
e_enum_OrderRequestType(V, Bin) -> e_varint(V, Bin).

e_enum_OrderReplyType('OK', Bin) -> <<Bin/binary, 0>>;
e_enum_OrderReplyType('NOT_OK', Bin) ->
    <<Bin/binary, 1>>;
e_enum_OrderReplyType('INVALID_COMPANY', Bin) ->
    <<Bin/binary, 2>>;
e_enum_OrderReplyType('NOT_LOGGED_IN', Bin) ->
    <<Bin/binary, 3>>;
e_enum_OrderReplyType(V, Bin) -> e_varint(V, Bin).

e_type_int32(Value, Bin)
    when 0 =< Value, Value =< 127 ->
    <<Bin/binary, Value>>;
e_type_int32(Value, Bin) ->
    <<N:64/unsigned-native>> = <<Value:64/signed-native>>,
    e_varint(N, Bin).

e_type_string(S, Bin) ->
    Utf8 = unicode:characters_to_binary(S),
    Bin2 = e_varint(byte_size(Utf8), Bin),
    <<Bin2/binary, Utf8/binary>>.

e_varint(N, Bin) when N =< 127 -> <<Bin/binary, N>>;
e_varint(N, Bin) ->
    Bin2 = <<Bin/binary, (N band 127 bor 128)>>,
    e_varint(N bsr 7, Bin2).

is_empty_string("") -> true;
is_empty_string(<<>>) -> true;
is_empty_string(L) when is_list(L) ->
    not string_has_chars(L);
is_empty_string(B) when is_binary(B) -> false.

string_has_chars([C | _]) when is_integer(C) -> true;
string_has_chars([H | T]) ->
    case string_has_chars(H) of
      true -> true;
      false -> string_has_chars(T)
    end;
string_has_chars(B)
    when is_binary(B), byte_size(B) =/= 0 ->
    true;
string_has_chars(C) when is_integer(C) -> true;
string_has_chars(<<>>) -> false;
string_has_chars([]) -> false.


decode_msg(Bin, MsgName) when is_binary(Bin) ->
    decode_msg(Bin, MsgName, []).

decode_msg(Bin, MsgName, Opts) when is_binary(Bin) ->
    TrUserData = proplists:get_value(user_data, Opts),
    case MsgName of
      'OrderRequestData' ->
	  try d_msg_OrderRequestData(Bin, TrUserData) catch
	    Class:Reason ->
		StackTrace = erlang:get_stacktrace(),
		error({gpb_error,
		       {decoding_failure,
			{Bin, 'OrderRequestData',
			 {Class, Reason, StackTrace}}}})
	  end;
      'OrderReplyData' ->
	  try d_msg_OrderReplyData(Bin, TrUserData) catch
	    Class:Reason ->
		StackTrace = erlang:get_stacktrace(),
		error({gpb_error,
		       {decoding_failure,
			{Bin, 'OrderReplyData', {Class, Reason, StackTrace}}}})
	  end
    end.



d_msg_OrderRequestData(Bin, TrUserData) ->
    dfp_read_field_def_OrderRequestData(Bin, 0, 0,
					id('BUY', TrUserData),
					id([], TrUserData), id(0, TrUserData),
					id(0, TrUserData), id([], TrUserData),
					TrUserData).

dfp_read_field_def_OrderRequestData(<<8, Rest/binary>>,
				    Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
				    TrUserData) ->
    d_field_OrderRequestData_order_type(Rest, Z1, Z2, F@_1,
					F@_2, F@_3, F@_4, F@_5, TrUserData);
dfp_read_field_def_OrderRequestData(<<18, Rest/binary>>,
				    Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
				    TrUserData) ->
    d_field_OrderRequestData_company(Rest, Z1, Z2, F@_1,
				     F@_2, F@_3, F@_4, F@_5, TrUserData);
dfp_read_field_def_OrderRequestData(<<24, Rest/binary>>,
				    Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
				    TrUserData) ->
    d_field_OrderRequestData_qtd(Rest, Z1, Z2, F@_1, F@_2,
				 F@_3, F@_4, F@_5, TrUserData);
dfp_read_field_def_OrderRequestData(<<32, Rest/binary>>,
				    Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
				    TrUserData) ->
    d_field_OrderRequestData_price(Rest, Z1, Z2, F@_1, F@_2,
				   F@_3, F@_4, F@_5, TrUserData);
dfp_read_field_def_OrderRequestData(<<42, Rest/binary>>,
				    Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
				    TrUserData) ->
    d_field_OrderRequestData_username(Rest, Z1, Z2, F@_1,
				      F@_2, F@_3, F@_4, F@_5, TrUserData);
dfp_read_field_def_OrderRequestData(<<>>, 0, 0, F@_1,
				    F@_2, F@_3, F@_4, F@_5, _) ->
    #'OrderRequestData'{order_type = F@_1, company = F@_2,
			qtd = F@_3, price = F@_4, username = F@_5};
dfp_read_field_def_OrderRequestData(Other, Z1, Z2, F@_1,
				    F@_2, F@_3, F@_4, F@_5, TrUserData) ->
    dg_read_field_def_OrderRequestData(Other, Z1, Z2, F@_1,
				       F@_2, F@_3, F@_4, F@_5, TrUserData).

dg_read_field_def_OrderRequestData(<<1:1, X:7,
				     Rest/binary>>,
				   N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				   TrUserData)
    when N < 32 - 7 ->
    dg_read_field_def_OrderRequestData(Rest, N + 7,
				       X bsl N + Acc, F@_1, F@_2, F@_3, F@_4,
				       F@_5, TrUserData);
dg_read_field_def_OrderRequestData(<<0:1, X:7,
				     Rest/binary>>,
				   N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				   TrUserData) ->
    Key = X bsl N + Acc,
    case Key of
      8 ->
	  d_field_OrderRequestData_order_type(Rest, 0, 0, F@_1,
					      F@_2, F@_3, F@_4, F@_5,
					      TrUserData);
      18 ->
	  d_field_OrderRequestData_company(Rest, 0, 0, F@_1, F@_2,
					   F@_3, F@_4, F@_5, TrUserData);
      24 ->
	  d_field_OrderRequestData_qtd(Rest, 0, 0, F@_1, F@_2,
				       F@_3, F@_4, F@_5, TrUserData);
      32 ->
	  d_field_OrderRequestData_price(Rest, 0, 0, F@_1, F@_2,
					 F@_3, F@_4, F@_5, TrUserData);
      42 ->
	  d_field_OrderRequestData_username(Rest, 0, 0, F@_1,
					    F@_2, F@_3, F@_4, F@_5, TrUserData);
      _ ->
	  case Key band 7 of
	    0 ->
		skip_varint_OrderRequestData(Rest, 0, 0, F@_1, F@_2,
					     F@_3, F@_4, F@_5, TrUserData);
	    1 ->
		skip_64_OrderRequestData(Rest, 0, 0, F@_1, F@_2, F@_3,
					 F@_4, F@_5, TrUserData);
	    2 ->
		skip_length_delimited_OrderRequestData(Rest, 0, 0, F@_1,
						       F@_2, F@_3, F@_4, F@_5,
						       TrUserData);
	    3 ->
		skip_group_OrderRequestData(Rest, Key bsr 3, 0, F@_1,
					    F@_2, F@_3, F@_4, F@_5, TrUserData);
	    5 ->
		skip_32_OrderRequestData(Rest, 0, 0, F@_1, F@_2, F@_3,
					 F@_4, F@_5, TrUserData)
	  end
    end;
dg_read_field_def_OrderRequestData(<<>>, 0, 0, F@_1,
				   F@_2, F@_3, F@_4, F@_5, _) ->
    #'OrderRequestData'{order_type = F@_1, company = F@_2,
			qtd = F@_3, price = F@_4, username = F@_5}.

d_field_OrderRequestData_order_type(<<1:1, X:7,
				      Rest/binary>>,
				    N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				    TrUserData)
    when N < 57 ->
    d_field_OrderRequestData_order_type(Rest, N + 7,
					X bsl N + Acc, F@_1, F@_2, F@_3, F@_4,
					F@_5, TrUserData);
d_field_OrderRequestData_order_type(<<0:1, X:7,
				      Rest/binary>>,
				    N, Acc, _, F@_2, F@_3, F@_4, F@_5,
				    TrUserData) ->
    {NewFValue, RestF} = {d_enum_OrderRequestType(begin
						    <<Res:32/signed-native>> =
							<<(X bsl N +
							     Acc):32/unsigned-native>>,
						    Res
						  end),
			  Rest},
    dfp_read_field_def_OrderRequestData(RestF, 0, 0,
					NewFValue, F@_2, F@_3, F@_4, F@_5,
					TrUserData).

d_field_OrderRequestData_company(<<1:1, X:7,
				   Rest/binary>>,
				 N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				 TrUserData)
    when N < 57 ->
    d_field_OrderRequestData_company(Rest, N + 7,
				     X bsl N + Acc, F@_1, F@_2, F@_3, F@_4,
				     F@_5, TrUserData);
d_field_OrderRequestData_company(<<0:1, X:7,
				   Rest/binary>>,
				 N, Acc, F@_1, _, F@_3, F@_4, F@_5,
				 TrUserData) ->
    {NewFValue, RestF} = begin
			   Len = X bsl N + Acc,
			   <<Utf8:Len/binary, Rest2/binary>> = Rest,
			   {unicode:characters_to_list(Utf8, unicode), Rest2}
			 end,
    dfp_read_field_def_OrderRequestData(RestF, 0, 0, F@_1,
					NewFValue, F@_3, F@_4, F@_5,
					TrUserData).

d_field_OrderRequestData_qtd(<<1:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5, TrUserData)
    when N < 57 ->
    d_field_OrderRequestData_qtd(Rest, N + 7, X bsl N + Acc,
				 F@_1, F@_2, F@_3, F@_4, F@_5, TrUserData);
d_field_OrderRequestData_qtd(<<0:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, F@_2, _, F@_4, F@_5, TrUserData) ->
    {NewFValue, RestF} = {begin
			    <<Res:32/signed-native>> = <<(X bsl N +
							    Acc):32/unsigned-native>>,
			    Res
			  end,
			  Rest},
    dfp_read_field_def_OrderRequestData(RestF, 0, 0, F@_1,
					F@_2, NewFValue, F@_4, F@_5,
					TrUserData).

d_field_OrderRequestData_price(<<1:1, X:7,
				 Rest/binary>>,
			       N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5, TrUserData)
    when N < 57 ->
    d_field_OrderRequestData_price(Rest, N + 7,
				   X bsl N + Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				   TrUserData);
d_field_OrderRequestData_price(<<0:1, X:7,
				 Rest/binary>>,
			       N, Acc, F@_1, F@_2, F@_3, _, F@_5, TrUserData) ->
    {NewFValue, RestF} = {begin
			    <<Res:32/signed-native>> = <<(X bsl N +
							    Acc):32/unsigned-native>>,
			    Res
			  end,
			  Rest},
    dfp_read_field_def_OrderRequestData(RestF, 0, 0, F@_1,
					F@_2, F@_3, NewFValue, F@_5,
					TrUserData).

d_field_OrderRequestData_username(<<1:1, X:7,
				    Rest/binary>>,
				  N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				  TrUserData)
    when N < 57 ->
    d_field_OrderRequestData_username(Rest, N + 7,
				      X bsl N + Acc, F@_1, F@_2, F@_3, F@_4,
				      F@_5, TrUserData);
d_field_OrderRequestData_username(<<0:1, X:7,
				    Rest/binary>>,
				  N, Acc, F@_1, F@_2, F@_3, F@_4, _,
				  TrUserData) ->
    {NewFValue, RestF} = begin
			   Len = X bsl N + Acc,
			   <<Utf8:Len/binary, Rest2/binary>> = Rest,
			   {unicode:characters_to_list(Utf8, unicode), Rest2}
			 end,
    dfp_read_field_def_OrderRequestData(RestF, 0, 0, F@_1,
					F@_2, F@_3, F@_4, NewFValue,
					TrUserData).

skip_varint_OrderRequestData(<<1:1, _:7, Rest/binary>>,
			     Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
			     TrUserData) ->
    skip_varint_OrderRequestData(Rest, Z1, Z2, F@_1, F@_2,
				 F@_3, F@_4, F@_5, TrUserData);
skip_varint_OrderRequestData(<<0:1, _:7, Rest/binary>>,
			     Z1, Z2, F@_1, F@_2, F@_3, F@_4, F@_5,
			     TrUserData) ->
    dfp_read_field_def_OrderRequestData(Rest, Z1, Z2, F@_1,
					F@_2, F@_3, F@_4, F@_5, TrUserData).

skip_length_delimited_OrderRequestData(<<1:1, X:7,
					 Rest/binary>>,
				       N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				       TrUserData)
    when N < 57 ->
    skip_length_delimited_OrderRequestData(Rest, N + 7,
					   X bsl N + Acc, F@_1, F@_2, F@_3,
					   F@_4, F@_5, TrUserData);
skip_length_delimited_OrderRequestData(<<0:1, X:7,
					 Rest/binary>>,
				       N, Acc, F@_1, F@_2, F@_3, F@_4, F@_5,
				       TrUserData) ->
    Length = X bsl N + Acc,
    <<_:Length/binary, Rest2/binary>> = Rest,
    dfp_read_field_def_OrderRequestData(Rest2, 0, 0, F@_1,
					F@_2, F@_3, F@_4, F@_5, TrUserData).

skip_group_OrderRequestData(Bin, FNum, Z2, F@_1, F@_2,
			    F@_3, F@_4, F@_5, TrUserData) ->
    {_, Rest} = read_group(Bin, FNum),
    dfp_read_field_def_OrderRequestData(Rest, 0, Z2, F@_1,
					F@_2, F@_3, F@_4, F@_5, TrUserData).

skip_32_OrderRequestData(<<_:32, Rest/binary>>, Z1, Z2,
			 F@_1, F@_2, F@_3, F@_4, F@_5, TrUserData) ->
    dfp_read_field_def_OrderRequestData(Rest, Z1, Z2, F@_1,
					F@_2, F@_3, F@_4, F@_5, TrUserData).

skip_64_OrderRequestData(<<_:64, Rest/binary>>, Z1, Z2,
			 F@_1, F@_2, F@_3, F@_4, F@_5, TrUserData) ->
    dfp_read_field_def_OrderRequestData(Rest, Z1, Z2, F@_1,
					F@_2, F@_3, F@_4, F@_5, TrUserData).

d_msg_OrderReplyData(Bin, TrUserData) ->
    dfp_read_field_def_OrderReplyData(Bin, 0, 0,
				      id('OK', TrUserData), TrUserData).

dfp_read_field_def_OrderReplyData(<<8, Rest/binary>>,
				  Z1, Z2, F@_1, TrUserData) ->
    d_field_OrderReplyData_reply_type(Rest, Z1, Z2, F@_1,
				      TrUserData);
dfp_read_field_def_OrderReplyData(<<>>, 0, 0, F@_1,
				  _) ->
    #'OrderReplyData'{reply_type = F@_1};
dfp_read_field_def_OrderReplyData(Other, Z1, Z2, F@_1,
				  TrUserData) ->
    dg_read_field_def_OrderReplyData(Other, Z1, Z2, F@_1,
				     TrUserData).

dg_read_field_def_OrderReplyData(<<1:1, X:7,
				   Rest/binary>>,
				 N, Acc, F@_1, TrUserData)
    when N < 32 - 7 ->
    dg_read_field_def_OrderReplyData(Rest, N + 7,
				     X bsl N + Acc, F@_1, TrUserData);
dg_read_field_def_OrderReplyData(<<0:1, X:7,
				   Rest/binary>>,
				 N, Acc, F@_1, TrUserData) ->
    Key = X bsl N + Acc,
    case Key of
      8 ->
	  d_field_OrderReplyData_reply_type(Rest, 0, 0, F@_1,
					    TrUserData);
      _ ->
	  case Key band 7 of
	    0 ->
		skip_varint_OrderReplyData(Rest, 0, 0, F@_1,
					   TrUserData);
	    1 ->
		skip_64_OrderReplyData(Rest, 0, 0, F@_1, TrUserData);
	    2 ->
		skip_length_delimited_OrderReplyData(Rest, 0, 0, F@_1,
						     TrUserData);
	    3 ->
		skip_group_OrderReplyData(Rest, Key bsr 3, 0, F@_1,
					  TrUserData);
	    5 ->
		skip_32_OrderReplyData(Rest, 0, 0, F@_1, TrUserData)
	  end
    end;
dg_read_field_def_OrderReplyData(<<>>, 0, 0, F@_1, _) ->
    #'OrderReplyData'{reply_type = F@_1}.

d_field_OrderReplyData_reply_type(<<1:1, X:7,
				    Rest/binary>>,
				  N, Acc, F@_1, TrUserData)
    when N < 57 ->
    d_field_OrderReplyData_reply_type(Rest, N + 7,
				      X bsl N + Acc, F@_1, TrUserData);
d_field_OrderReplyData_reply_type(<<0:1, X:7,
				    Rest/binary>>,
				  N, Acc, _, TrUserData) ->
    {NewFValue, RestF} = {d_enum_OrderReplyType(begin
						  <<Res:32/signed-native>> =
						      <<(X bsl N +
							   Acc):32/unsigned-native>>,
						  Res
						end),
			  Rest},
    dfp_read_field_def_OrderReplyData(RestF, 0, 0,
				      NewFValue, TrUserData).

skip_varint_OrderReplyData(<<1:1, _:7, Rest/binary>>,
			   Z1, Z2, F@_1, TrUserData) ->
    skip_varint_OrderReplyData(Rest, Z1, Z2, F@_1,
			       TrUserData);
skip_varint_OrderReplyData(<<0:1, _:7, Rest/binary>>,
			   Z1, Z2, F@_1, TrUserData) ->
    dfp_read_field_def_OrderReplyData(Rest, Z1, Z2, F@_1,
				      TrUserData).

skip_length_delimited_OrderReplyData(<<1:1, X:7,
				       Rest/binary>>,
				     N, Acc, F@_1, TrUserData)
    when N < 57 ->
    skip_length_delimited_OrderReplyData(Rest, N + 7,
					 X bsl N + Acc, F@_1, TrUserData);
skip_length_delimited_OrderReplyData(<<0:1, X:7,
				       Rest/binary>>,
				     N, Acc, F@_1, TrUserData) ->
    Length = X bsl N + Acc,
    <<_:Length/binary, Rest2/binary>> = Rest,
    dfp_read_field_def_OrderReplyData(Rest2, 0, 0, F@_1,
				      TrUserData).

skip_group_OrderReplyData(Bin, FNum, Z2, F@_1,
			  TrUserData) ->
    {_, Rest} = read_group(Bin, FNum),
    dfp_read_field_def_OrderReplyData(Rest, 0, Z2, F@_1,
				      TrUserData).

skip_32_OrderReplyData(<<_:32, Rest/binary>>, Z1, Z2,
		       F@_1, TrUserData) ->
    dfp_read_field_def_OrderReplyData(Rest, Z1, Z2, F@_1,
				      TrUserData).

skip_64_OrderReplyData(<<_:64, Rest/binary>>, Z1, Z2,
		       F@_1, TrUserData) ->
    dfp_read_field_def_OrderReplyData(Rest, Z1, Z2, F@_1,
				      TrUserData).

d_enum_OrderRequestType(0) -> 'BUY';
d_enum_OrderRequestType(1) -> 'SELL';
d_enum_OrderRequestType(V) -> V.

d_enum_OrderReplyType(0) -> 'OK';
d_enum_OrderReplyType(1) -> 'NOT_OK';
d_enum_OrderReplyType(2) -> 'INVALID_COMPANY';
d_enum_OrderReplyType(3) -> 'NOT_LOGGED_IN';
d_enum_OrderReplyType(V) -> V.

read_group(Bin, FieldNum) ->
    {NumBytes, EndTagLen} = read_gr_b(Bin, 0, 0, 0, 0, FieldNum),
    <<Group:NumBytes/binary, _:EndTagLen/binary, Rest/binary>> = Bin,
    {Group, Rest}.

%% Like skipping over fields, but record the total length,
%% Each field is <(FieldNum bsl 3) bor FieldType> ++ <FieldValue>
%% Record the length because varints may be non-optimally encoded.
%%
%% Groups can be nested, but assume the same FieldNum cannot be nested
%% because group field numbers are shared with the rest of the fields
%% numbers. Thus we can search just for an group-end with the same
%% field number.
%%
%% (The only time the same group field number could occur would
%% be in a nested sub message, but then it would be inside a
%% length-delimited entry, which we skip-read by length.)
read_gr_b(<<1:1, X:7, Tl/binary>>, N, Acc, NumBytes, TagLen, FieldNum)
  when N < (32-7) ->
    read_gr_b(Tl, N+7, X bsl N + Acc, NumBytes, TagLen+1, FieldNum);
read_gr_b(<<0:1, X:7, Tl/binary>>, N, Acc, NumBytes, TagLen,
          FieldNum) ->
    Key = X bsl N + Acc,
    TagLen1 = TagLen + 1,
    case {Key bsr 3, Key band 7} of
        {FieldNum, 4} -> % 4 = group_end
            {NumBytes, TagLen1};
        {_, 0} -> % 0 = varint
            read_gr_vi(Tl, 0, NumBytes + TagLen1, FieldNum);
        {_, 1} -> % 1 = bits64
            <<_:64, Tl2/binary>> = Tl,
            read_gr_b(Tl2, 0, 0, NumBytes + TagLen1 + 8, 0, FieldNum);
        {_, 2} -> % 2 = length_delimited
            read_gr_ld(Tl, 0, 0, NumBytes + TagLen1, FieldNum);
        {_, 3} -> % 3 = group_start
            read_gr_b(Tl, 0, 0, NumBytes + TagLen1, 0, FieldNum);
        {_, 4} -> % 4 = group_end
            read_gr_b(Tl, 0, 0, NumBytes + TagLen1, 0, FieldNum);
        {_, 5} -> % 5 = bits32
            <<_:32, Tl2/binary>> = Tl,
            read_gr_b(Tl2, 0, 0, NumBytes + TagLen1 + 4, 0, FieldNum)
    end.

read_gr_vi(<<1:1, _:7, Tl/binary>>, N, NumBytes, FieldNum)
  when N < (64-7) ->
    read_gr_vi(Tl, N+7, NumBytes+1, FieldNum);
read_gr_vi(<<0:1, _:7, Tl/binary>>, _, NumBytes, FieldNum) ->
    read_gr_b(Tl, 0, 0, NumBytes+1, 0, FieldNum).

read_gr_ld(<<1:1, X:7, Tl/binary>>, N, Acc, NumBytes, FieldNum)
  when N < (64-7) ->
    read_gr_ld(Tl, N+7, X bsl N + Acc, NumBytes+1, FieldNum);
read_gr_ld(<<0:1, X:7, Tl/binary>>, N, Acc, NumBytes, FieldNum) ->
    Len = X bsl N + Acc,
    NumBytes1 = NumBytes + 1,
    <<_:Len/binary, Tl2/binary>> = Tl,
    read_gr_b(Tl2, 0, 0, NumBytes1 + Len, 0, FieldNum).

merge_msgs(Prev, New) -> merge_msgs(Prev, New, []).

merge_msgs(Prev, New, Opts)
    when element(1, Prev) =:= element(1, New) ->
    TrUserData = proplists:get_value(user_data, Opts),
    case Prev of
      #'OrderRequestData'{} ->
	  merge_msg_OrderRequestData(Prev, New, TrUserData);
      #'OrderReplyData'{} ->
	  merge_msg_OrderReplyData(Prev, New, TrUserData)
    end.

merge_msg_OrderRequestData(#'OrderRequestData'{order_type
						   = PForder_type,
					       company = PFcompany, qtd = PFqtd,
					       price = PFprice,
					       username = PFusername},
			   #'OrderRequestData'{order_type = NForder_type,
					       company = NFcompany, qtd = NFqtd,
					       price = NFprice,
					       username = NFusername},
			   _) ->
    #'OrderRequestData'{order_type =
			    if NForder_type =:= undefined -> PForder_type;
			       true -> NForder_type
			    end,
			company =
			    if NFcompany =:= undefined -> PFcompany;
			       true -> NFcompany
			    end,
			qtd =
			    if NFqtd =:= undefined -> PFqtd;
			       true -> NFqtd
			    end,
			price =
			    if NFprice =:= undefined -> PFprice;
			       true -> NFprice
			    end,
			username =
			    if NFusername =:= undefined -> PFusername;
			       true -> NFusername
			    end}.

merge_msg_OrderReplyData(#'OrderReplyData'{reply_type =
					       PFreply_type},
			 #'OrderReplyData'{reply_type = NFreply_type}, _) ->
    #'OrderReplyData'{reply_type =
			  if NFreply_type =:= undefined -> PFreply_type;
			     true -> NFreply_type
			  end}.


verify_msg(Msg) -> verify_msg(Msg, []).

verify_msg(Msg, Opts) ->
    TrUserData = proplists:get_value(user_data, Opts),
    case Msg of
      #'OrderRequestData'{} ->
	  v_msg_OrderRequestData(Msg, ['OrderRequestData'],
				 TrUserData);
      #'OrderReplyData'{} ->
	  v_msg_OrderReplyData(Msg, ['OrderReplyData'],
			       TrUserData);
      _ -> mk_type_error(not_a_known_message, Msg, [])
    end.


-dialyzer({nowarn_function,v_msg_OrderRequestData/3}).
v_msg_OrderRequestData(#'OrderRequestData'{order_type =
					       F1,
					   company = F2, qtd = F3, price = F4,
					   username = F5},
		       Path, _) ->
    if F1 == undefined -> ok;
       true -> v_enum_OrderRequestType(F1, [order_type | Path])
    end,
    if F2 == undefined -> ok;
       true -> v_type_string(F2, [company | Path])
    end,
    if F3 == undefined -> ok;
       true -> v_type_int32(F3, [qtd | Path])
    end,
    if F4 == undefined -> ok;
       true -> v_type_int32(F4, [price | Path])
    end,
    if F5 == undefined -> ok;
       true -> v_type_string(F5, [username | Path])
    end,
    ok.

-dialyzer({nowarn_function,v_msg_OrderReplyData/3}).
v_msg_OrderReplyData(#'OrderReplyData'{reply_type = F1},
		     Path, _) ->
    if F1 == undefined -> ok;
       true -> v_enum_OrderReplyType(F1, [reply_type | Path])
    end,
    ok.

-dialyzer({nowarn_function,v_enum_OrderRequestType/2}).
v_enum_OrderRequestType('BUY', _Path) -> ok;
v_enum_OrderRequestType('SELL', _Path) -> ok;
v_enum_OrderRequestType(V, Path) when is_integer(V) ->
    v_type_sint32(V, Path);
v_enum_OrderRequestType(X, Path) ->
    mk_type_error({invalid_enum, 'OrderRequestType'}, X,
		  Path).

-dialyzer({nowarn_function,v_enum_OrderReplyType/2}).
v_enum_OrderReplyType('OK', _Path) -> ok;
v_enum_OrderReplyType('NOT_OK', _Path) -> ok;
v_enum_OrderReplyType('INVALID_COMPANY', _Path) -> ok;
v_enum_OrderReplyType('NOT_LOGGED_IN', _Path) -> ok;
v_enum_OrderReplyType(V, Path) when is_integer(V) ->
    v_type_sint32(V, Path);
v_enum_OrderReplyType(X, Path) ->
    mk_type_error({invalid_enum, 'OrderReplyType'}, X,
		  Path).

-dialyzer({nowarn_function,v_type_sint32/2}).
v_type_sint32(N, _Path)
    when -2147483648 =< N, N =< 2147483647 ->
    ok;
v_type_sint32(N, Path) when is_integer(N) ->
    mk_type_error({value_out_of_range, sint32, signed, 32},
		  N, Path);
v_type_sint32(X, Path) ->
    mk_type_error({bad_integer, sint32, signed, 32}, X,
		  Path).

-dialyzer({nowarn_function,v_type_int32/2}).
v_type_int32(N, _Path)
    when -2147483648 =< N, N =< 2147483647 ->
    ok;
v_type_int32(N, Path) when is_integer(N) ->
    mk_type_error({value_out_of_range, int32, signed, 32},
		  N, Path);
v_type_int32(X, Path) ->
    mk_type_error({bad_integer, int32, signed, 32}, X,
		  Path).

-dialyzer({nowarn_function,v_type_string/2}).
v_type_string(S, Path) when is_list(S); is_binary(S) ->
    try unicode:characters_to_binary(S) of
      B when is_binary(B) -> ok;
      {error, _, _} ->
	  mk_type_error(bad_unicode_string, S, Path)
    catch
      error:badarg ->
	  mk_type_error(bad_unicode_string, S, Path)
    end;
v_type_string(X, Path) ->
    mk_type_error(bad_unicode_string, X, Path).

-spec mk_type_error(_, _, list()) -> no_return().
mk_type_error(Error, ValueSeen, Path) ->
    Path2 = prettify_path(Path),
    erlang:error({gpb_type_error,
		  {Error, [{value, ValueSeen}, {path, Path2}]}}).


prettify_path([]) -> top_level;
prettify_path(PathR) ->
    list_to_atom(lists:append(lists:join(".",
					 lists:map(fun atom_to_list/1,
						   lists:reverse(PathR))))).


-compile({inline,id/2}).
id(X, _TrUserData) -> X.


get_msg_defs() ->
    [{{enum, 'OrderRequestType'},
      [{'BUY', 0}, {'SELL', 1}]},
     {{enum, 'OrderReplyType'},
      [{'OK', 0}, {'NOT_OK', 1}, {'INVALID_COMPANY', 2},
       {'NOT_LOGGED_IN', 3}]},
     {{msg, 'OrderRequestData'},
      [#field{name = order_type, fnum = 1, rnum = 2,
	      type = {enum, 'OrderRequestType'},
	      occurrence = optional, opts = []},
       #field{name = company, fnum = 2, rnum = 3,
	      type = string, occurrence = optional, opts = []},
       #field{name = qtd, fnum = 3, rnum = 4, type = int32,
	      occurrence = optional, opts = []},
       #field{name = price, fnum = 4, rnum = 5, type = int32,
	      occurrence = optional, opts = []},
       #field{name = username, fnum = 5, rnum = 6,
	      type = string, occurrence = optional, opts = []}]},
     {{msg, 'OrderReplyData'},
      [#field{name = reply_type, fnum = 1, rnum = 2,
	      type = {enum, 'OrderReplyType'}, occurrence = optional,
	      opts = []}]}].


get_msg_names() ->
    ['OrderRequestData', 'OrderReplyData'].


get_group_names() -> [].


get_msg_or_group_names() ->
    ['OrderRequestData', 'OrderReplyData'].


get_enum_names() ->
    ['OrderRequestType', 'OrderReplyType'].


fetch_msg_def(MsgName) ->
    case find_msg_def(MsgName) of
      Fs when is_list(Fs) -> Fs;
      error -> erlang:error({no_such_msg, MsgName})
    end.


fetch_enum_def(EnumName) ->
    case find_enum_def(EnumName) of
      Es when is_list(Es) -> Es;
      error -> erlang:error({no_such_enum, EnumName})
    end.


find_msg_def('OrderRequestData') ->
    [#field{name = order_type, fnum = 1, rnum = 2,
	    type = {enum, 'OrderRequestType'},
	    occurrence = optional, opts = []},
     #field{name = company, fnum = 2, rnum = 3,
	    type = string, occurrence = optional, opts = []},
     #field{name = qtd, fnum = 3, rnum = 4, type = int32,
	    occurrence = optional, opts = []},
     #field{name = price, fnum = 4, rnum = 5, type = int32,
	    occurrence = optional, opts = []},
     #field{name = username, fnum = 5, rnum = 6,
	    type = string, occurrence = optional, opts = []}];
find_msg_def('OrderReplyData') ->
    [#field{name = reply_type, fnum = 1, rnum = 2,
	    type = {enum, 'OrderReplyType'}, occurrence = optional,
	    opts = []}];
find_msg_def(_) -> error.


find_enum_def('OrderRequestType') ->
    [{'BUY', 0}, {'SELL', 1}];
find_enum_def('OrderReplyType') ->
    [{'OK', 0}, {'NOT_OK', 1}, {'INVALID_COMPANY', 2},
     {'NOT_LOGGED_IN', 3}];
find_enum_def(_) -> error.


enum_symbol_by_value('OrderRequestType', Value) ->
    enum_symbol_by_value_OrderRequestType(Value);
enum_symbol_by_value('OrderReplyType', Value) ->
    enum_symbol_by_value_OrderReplyType(Value).


enum_value_by_symbol('OrderRequestType', Sym) ->
    enum_value_by_symbol_OrderRequestType(Sym);
enum_value_by_symbol('OrderReplyType', Sym) ->
    enum_value_by_symbol_OrderReplyType(Sym).


enum_symbol_by_value_OrderRequestType(0) -> 'BUY';
enum_symbol_by_value_OrderRequestType(1) -> 'SELL'.


enum_value_by_symbol_OrderRequestType('BUY') -> 0;
enum_value_by_symbol_OrderRequestType('SELL') -> 1.

enum_symbol_by_value_OrderReplyType(0) -> 'OK';
enum_symbol_by_value_OrderReplyType(1) -> 'NOT_OK';
enum_symbol_by_value_OrderReplyType(2) ->
    'INVALID_COMPANY';
enum_symbol_by_value_OrderReplyType(3) ->
    'NOT_LOGGED_IN'.


enum_value_by_symbol_OrderReplyType('OK') -> 0;
enum_value_by_symbol_OrderReplyType('NOT_OK') -> 1;
enum_value_by_symbol_OrderReplyType('INVALID_COMPANY') ->
    2;
enum_value_by_symbol_OrderReplyType('NOT_LOGGED_IN') ->
    3.


get_service_names() -> [].


get_service_def(_) -> error.


get_rpc_names(_) -> error.


find_rpc_def(_, _) -> error.



-spec fetch_rpc_def(_, _) -> no_return().
fetch_rpc_def(ServiceName, RpcName) ->
    erlang:error({no_such_rpc, ServiceName, RpcName}).


get_package_name() -> order.



gpb_version_as_string() ->
    "4.1.1".

gpb_version_as_list() ->
    [4,1,1].
