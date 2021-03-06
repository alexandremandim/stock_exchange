%% -*- coding: utf-8 -*-
%% Automatically generated, do not edit
%% Generated by gpb_compile version 4.1.1
-module(auth).

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
-export([enum_symbol_by_value_AuthRequestType/1, enum_value_by_symbol_AuthRequestType/1]).
-export([enum_symbol_by_value_AuthReplyType/1, enum_value_by_symbol_AuthReplyType/1]).
-export([get_service_names/0]).
-export([get_service_def/1]).
-export([get_rpc_names/1]).
-export([find_rpc_def/2, fetch_rpc_def/2]).
-export([get_package_name/0]).
-export([gpb_version_as_string/0, gpb_version_as_list/0]).

-include("auth.hrl").
-include("gpb.hrl").

%% enumerated types
-type 'AuthRequestType'() :: 'LOGIN' | 'LOGOUT'.
-type 'AuthReplyType'() :: 'OK' | 'WRONG_USER' | 'WRONG_PASSWORD' | 'NOT_OK' | 'NOT_LOGGED_IN'.
-export_type(['AuthRequestType'/0, 'AuthReplyType'/0]).

%% message types
-type 'AuthRequest'() :: #'AuthRequest'{}.
-type 'AuthReply'() :: #'AuthReply'{}.
-export_type(['AuthRequest'/0, 'AuthReply'/0]).

-spec encode_msg(#'AuthRequest'{} | #'AuthReply'{}) -> binary().
encode_msg(Msg) -> encode_msg(Msg, []).


-spec encode_msg(#'AuthRequest'{} | #'AuthReply'{}, list()) -> binary().
encode_msg(Msg, Opts) ->
    case proplists:get_bool(verify, Opts) of
      true -> verify_msg(Msg, Opts);
      false -> ok
    end,
    TrUserData = proplists:get_value(user_data, Opts),
    case Msg of
      #'AuthRequest'{} -> e_msg_AuthRequest(Msg, TrUserData);
      #'AuthReply'{} -> e_msg_AuthReply(Msg, TrUserData)
    end.



e_msg_AuthRequest(Msg, TrUserData) ->
    e_msg_AuthRequest(Msg, <<>>, TrUserData).


e_msg_AuthRequest(#'AuthRequest'{auth_type = F1,
				 username = F2, password = F3},
		  Bin, TrUserData) ->
    B1 = if F1 == undefined -> Bin;
	    true ->
		begin
		  TrF1 = id(F1, TrUserData),
		  if TrF1 =:= 'LOGIN' -> Bin;
		     true -> e_enum_AuthRequestType(TrF1, <<Bin/binary, 8>>)
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
    if F3 == undefined -> B2;
       true ->
	   begin
	     TrF3 = id(F3, TrUserData),
	     case is_empty_string(TrF3) of
	       true -> B2;
	       false -> e_type_string(TrF3, <<B2/binary, 26>>)
	     end
	   end
    end.

e_msg_AuthReply(Msg, TrUserData) ->
    e_msg_AuthReply(Msg, <<>>, TrUserData).


e_msg_AuthReply(#'AuthReply'{reply_type = F1}, Bin,
		TrUserData) ->
    if F1 == undefined -> Bin;
       true ->
	   begin
	     TrF1 = id(F1, TrUserData),
	     if TrF1 =:= 'OK' -> Bin;
		true -> e_enum_AuthReplyType(TrF1, <<Bin/binary, 8>>)
	     end
	   end
    end.

e_enum_AuthRequestType('LOGIN', Bin) ->
    <<Bin/binary, 0>>;
e_enum_AuthRequestType('LOGOUT', Bin) ->
    <<Bin/binary, 1>>;
e_enum_AuthRequestType(V, Bin) -> e_varint(V, Bin).

e_enum_AuthReplyType('OK', Bin) -> <<Bin/binary, 0>>;
e_enum_AuthReplyType('WRONG_USER', Bin) ->
    <<Bin/binary, 1>>;
e_enum_AuthReplyType('WRONG_PASSWORD', Bin) ->
    <<Bin/binary, 2>>;
e_enum_AuthReplyType('NOT_OK', Bin) ->
    <<Bin/binary, 3>>;
e_enum_AuthReplyType('NOT_LOGGED_IN', Bin) ->
    <<Bin/binary, 4>>;
e_enum_AuthReplyType(V, Bin) -> e_varint(V, Bin).

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
      'AuthRequest' ->
	  try d_msg_AuthRequest(Bin, TrUserData) catch
	    Class:Reason ->
		StackTrace = erlang:get_stacktrace(),
		error({gpb_error,
		       {decoding_failure,
			{Bin, 'AuthRequest', {Class, Reason, StackTrace}}}})
	  end;
      'AuthReply' ->
	  try d_msg_AuthReply(Bin, TrUserData) catch
	    Class:Reason ->
		StackTrace = erlang:get_stacktrace(),
		error({gpb_error,
		       {decoding_failure,
			{Bin, 'AuthReply', {Class, Reason, StackTrace}}}})
	  end
    end.



d_msg_AuthRequest(Bin, TrUserData) ->
    dfp_read_field_def_AuthRequest(Bin, 0, 0,
				   id('LOGIN', TrUserData), id([], TrUserData),
				   id([], TrUserData), TrUserData).

dfp_read_field_def_AuthRequest(<<8, Rest/binary>>, Z1,
			       Z2, F@_1, F@_2, F@_3, TrUserData) ->
    d_field_AuthRequest_auth_type(Rest, Z1, Z2, F@_1, F@_2,
				  F@_3, TrUserData);
dfp_read_field_def_AuthRequest(<<18, Rest/binary>>, Z1,
			       Z2, F@_1, F@_2, F@_3, TrUserData) ->
    d_field_AuthRequest_username(Rest, Z1, Z2, F@_1, F@_2,
				 F@_3, TrUserData);
dfp_read_field_def_AuthRequest(<<26, Rest/binary>>, Z1,
			       Z2, F@_1, F@_2, F@_3, TrUserData) ->
    d_field_AuthRequest_password(Rest, Z1, Z2, F@_1, F@_2,
				 F@_3, TrUserData);
dfp_read_field_def_AuthRequest(<<>>, 0, 0, F@_1, F@_2,
			       F@_3, _) ->
    #'AuthRequest'{auth_type = F@_1, username = F@_2,
		   password = F@_3};
dfp_read_field_def_AuthRequest(Other, Z1, Z2, F@_1,
			       F@_2, F@_3, TrUserData) ->
    dg_read_field_def_AuthRequest(Other, Z1, Z2, F@_1, F@_2,
				  F@_3, TrUserData).

dg_read_field_def_AuthRequest(<<1:1, X:7, Rest/binary>>,
			      N, Acc, F@_1, F@_2, F@_3, TrUserData)
    when N < 32 - 7 ->
    dg_read_field_def_AuthRequest(Rest, N + 7,
				  X bsl N + Acc, F@_1, F@_2, F@_3, TrUserData);
dg_read_field_def_AuthRequest(<<0:1, X:7, Rest/binary>>,
			      N, Acc, F@_1, F@_2, F@_3, TrUserData) ->
    Key = X bsl N + Acc,
    case Key of
      8 ->
	  d_field_AuthRequest_auth_type(Rest, 0, 0, F@_1, F@_2,
					F@_3, TrUserData);
      18 ->
	  d_field_AuthRequest_username(Rest, 0, 0, F@_1, F@_2,
				       F@_3, TrUserData);
      26 ->
	  d_field_AuthRequest_password(Rest, 0, 0, F@_1, F@_2,
				       F@_3, TrUserData);
      _ ->
	  case Key band 7 of
	    0 ->
		skip_varint_AuthRequest(Rest, 0, 0, F@_1, F@_2, F@_3,
					TrUserData);
	    1 ->
		skip_64_AuthRequest(Rest, 0, 0, F@_1, F@_2, F@_3,
				    TrUserData);
	    2 ->
		skip_length_delimited_AuthRequest(Rest, 0, 0, F@_1,
						  F@_2, F@_3, TrUserData);
	    3 ->
		skip_group_AuthRequest(Rest, Key bsr 3, 0, F@_1, F@_2,
				       F@_3, TrUserData);
	    5 ->
		skip_32_AuthRequest(Rest, 0, 0, F@_1, F@_2, F@_3,
				    TrUserData)
	  end
    end;
dg_read_field_def_AuthRequest(<<>>, 0, 0, F@_1, F@_2,
			      F@_3, _) ->
    #'AuthRequest'{auth_type = F@_1, username = F@_2,
		   password = F@_3}.

d_field_AuthRequest_auth_type(<<1:1, X:7, Rest/binary>>,
			      N, Acc, F@_1, F@_2, F@_3, TrUserData)
    when N < 57 ->
    d_field_AuthRequest_auth_type(Rest, N + 7,
				  X bsl N + Acc, F@_1, F@_2, F@_3, TrUserData);
d_field_AuthRequest_auth_type(<<0:1, X:7, Rest/binary>>,
			      N, Acc, _, F@_2, F@_3, TrUserData) ->
    {NewFValue, RestF} = {d_enum_AuthRequestType(begin
						   <<Res:32/signed-native>> =
						       <<(X bsl N +
							    Acc):32/unsigned-native>>,
						   Res
						 end),
			  Rest},
    dfp_read_field_def_AuthRequest(RestF, 0, 0, NewFValue,
				   F@_2, F@_3, TrUserData).

d_field_AuthRequest_username(<<1:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, F@_2, F@_3, TrUserData)
    when N < 57 ->
    d_field_AuthRequest_username(Rest, N + 7, X bsl N + Acc,
				 F@_1, F@_2, F@_3, TrUserData);
d_field_AuthRequest_username(<<0:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, _, F@_3, TrUserData) ->
    {NewFValue, RestF} = begin
			   Len = X bsl N + Acc,
			   <<Utf8:Len/binary, Rest2/binary>> = Rest,
			   {unicode:characters_to_list(Utf8, unicode), Rest2}
			 end,
    dfp_read_field_def_AuthRequest(RestF, 0, 0, F@_1,
				   NewFValue, F@_3, TrUserData).

d_field_AuthRequest_password(<<1:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, F@_2, F@_3, TrUserData)
    when N < 57 ->
    d_field_AuthRequest_password(Rest, N + 7, X bsl N + Acc,
				 F@_1, F@_2, F@_3, TrUserData);
d_field_AuthRequest_password(<<0:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, F@_2, _, TrUserData) ->
    {NewFValue, RestF} = begin
			   Len = X bsl N + Acc,
			   <<Utf8:Len/binary, Rest2/binary>> = Rest,
			   {unicode:characters_to_list(Utf8, unicode), Rest2}
			 end,
    dfp_read_field_def_AuthRequest(RestF, 0, 0, F@_1, F@_2,
				   NewFValue, TrUserData).

skip_varint_AuthRequest(<<1:1, _:7, Rest/binary>>, Z1,
			Z2, F@_1, F@_2, F@_3, TrUserData) ->
    skip_varint_AuthRequest(Rest, Z1, Z2, F@_1, F@_2, F@_3,
			    TrUserData);
skip_varint_AuthRequest(<<0:1, _:7, Rest/binary>>, Z1,
			Z2, F@_1, F@_2, F@_3, TrUserData) ->
    dfp_read_field_def_AuthRequest(Rest, Z1, Z2, F@_1, F@_2,
				   F@_3, TrUserData).

skip_length_delimited_AuthRequest(<<1:1, X:7,
				    Rest/binary>>,
				  N, Acc, F@_1, F@_2, F@_3, TrUserData)
    when N < 57 ->
    skip_length_delimited_AuthRequest(Rest, N + 7,
				      X bsl N + Acc, F@_1, F@_2, F@_3,
				      TrUserData);
skip_length_delimited_AuthRequest(<<0:1, X:7,
				    Rest/binary>>,
				  N, Acc, F@_1, F@_2, F@_3, TrUserData) ->
    Length = X bsl N + Acc,
    <<_:Length/binary, Rest2/binary>> = Rest,
    dfp_read_field_def_AuthRequest(Rest2, 0, 0, F@_1, F@_2,
				   F@_3, TrUserData).

skip_group_AuthRequest(Bin, FNum, Z2, F@_1, F@_2, F@_3,
		       TrUserData) ->
    {_, Rest} = read_group(Bin, FNum),
    dfp_read_field_def_AuthRequest(Rest, 0, Z2, F@_1, F@_2,
				   F@_3, TrUserData).

skip_32_AuthRequest(<<_:32, Rest/binary>>, Z1, Z2, F@_1,
		    F@_2, F@_3, TrUserData) ->
    dfp_read_field_def_AuthRequest(Rest, Z1, Z2, F@_1, F@_2,
				   F@_3, TrUserData).

skip_64_AuthRequest(<<_:64, Rest/binary>>, Z1, Z2, F@_1,
		    F@_2, F@_3, TrUserData) ->
    dfp_read_field_def_AuthRequest(Rest, Z1, Z2, F@_1, F@_2,
				   F@_3, TrUserData).

d_msg_AuthReply(Bin, TrUserData) ->
    dfp_read_field_def_AuthReply(Bin, 0, 0,
				 id('OK', TrUserData), TrUserData).

dfp_read_field_def_AuthReply(<<8, Rest/binary>>, Z1, Z2,
			     F@_1, TrUserData) ->
    d_field_AuthReply_reply_type(Rest, Z1, Z2, F@_1,
				 TrUserData);
dfp_read_field_def_AuthReply(<<>>, 0, 0, F@_1, _) ->
    #'AuthReply'{reply_type = F@_1};
dfp_read_field_def_AuthReply(Other, Z1, Z2, F@_1,
			     TrUserData) ->
    dg_read_field_def_AuthReply(Other, Z1, Z2, F@_1,
				TrUserData).

dg_read_field_def_AuthReply(<<1:1, X:7, Rest/binary>>,
			    N, Acc, F@_1, TrUserData)
    when N < 32 - 7 ->
    dg_read_field_def_AuthReply(Rest, N + 7, X bsl N + Acc,
				F@_1, TrUserData);
dg_read_field_def_AuthReply(<<0:1, X:7, Rest/binary>>,
			    N, Acc, F@_1, TrUserData) ->
    Key = X bsl N + Acc,
    case Key of
      8 ->
	  d_field_AuthReply_reply_type(Rest, 0, 0, F@_1,
				       TrUserData);
      _ ->
	  case Key band 7 of
	    0 ->
		skip_varint_AuthReply(Rest, 0, 0, F@_1, TrUserData);
	    1 -> skip_64_AuthReply(Rest, 0, 0, F@_1, TrUserData);
	    2 ->
		skip_length_delimited_AuthReply(Rest, 0, 0, F@_1,
						TrUserData);
	    3 ->
		skip_group_AuthReply(Rest, Key bsr 3, 0, F@_1,
				     TrUserData);
	    5 -> skip_32_AuthReply(Rest, 0, 0, F@_1, TrUserData)
	  end
    end;
dg_read_field_def_AuthReply(<<>>, 0, 0, F@_1, _) ->
    #'AuthReply'{reply_type = F@_1}.

d_field_AuthReply_reply_type(<<1:1, X:7, Rest/binary>>,
			     N, Acc, F@_1, TrUserData)
    when N < 57 ->
    d_field_AuthReply_reply_type(Rest, N + 7, X bsl N + Acc,
				 F@_1, TrUserData);
d_field_AuthReply_reply_type(<<0:1, X:7, Rest/binary>>,
			     N, Acc, _, TrUserData) ->
    {NewFValue, RestF} = {d_enum_AuthReplyType(begin
						 <<Res:32/signed-native>> = <<(X
										 bsl
										 N
										 +
										 Acc):32/unsigned-native>>,
						 Res
					       end),
			  Rest},
    dfp_read_field_def_AuthReply(RestF, 0, 0, NewFValue,
				 TrUserData).

skip_varint_AuthReply(<<1:1, _:7, Rest/binary>>, Z1, Z2,
		      F@_1, TrUserData) ->
    skip_varint_AuthReply(Rest, Z1, Z2, F@_1, TrUserData);
skip_varint_AuthReply(<<0:1, _:7, Rest/binary>>, Z1, Z2,
		      F@_1, TrUserData) ->
    dfp_read_field_def_AuthReply(Rest, Z1, Z2, F@_1,
				 TrUserData).

skip_length_delimited_AuthReply(<<1:1, X:7,
				  Rest/binary>>,
				N, Acc, F@_1, TrUserData)
    when N < 57 ->
    skip_length_delimited_AuthReply(Rest, N + 7,
				    X bsl N + Acc, F@_1, TrUserData);
skip_length_delimited_AuthReply(<<0:1, X:7,
				  Rest/binary>>,
				N, Acc, F@_1, TrUserData) ->
    Length = X bsl N + Acc,
    <<_:Length/binary, Rest2/binary>> = Rest,
    dfp_read_field_def_AuthReply(Rest2, 0, 0, F@_1,
				 TrUserData).

skip_group_AuthReply(Bin, FNum, Z2, F@_1, TrUserData) ->
    {_, Rest} = read_group(Bin, FNum),
    dfp_read_field_def_AuthReply(Rest, 0, Z2, F@_1,
				 TrUserData).

skip_32_AuthReply(<<_:32, Rest/binary>>, Z1, Z2, F@_1,
		  TrUserData) ->
    dfp_read_field_def_AuthReply(Rest, Z1, Z2, F@_1,
				 TrUserData).

skip_64_AuthReply(<<_:64, Rest/binary>>, Z1, Z2, F@_1,
		  TrUserData) ->
    dfp_read_field_def_AuthReply(Rest, Z1, Z2, F@_1,
				 TrUserData).

d_enum_AuthRequestType(0) -> 'LOGIN';
d_enum_AuthRequestType(1) -> 'LOGOUT';
d_enum_AuthRequestType(V) -> V.

d_enum_AuthReplyType(0) -> 'OK';
d_enum_AuthReplyType(1) -> 'WRONG_USER';
d_enum_AuthReplyType(2) -> 'WRONG_PASSWORD';
d_enum_AuthReplyType(3) -> 'NOT_OK';
d_enum_AuthReplyType(4) -> 'NOT_LOGGED_IN';
d_enum_AuthReplyType(V) -> V.

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
      #'AuthRequest'{} ->
	  merge_msg_AuthRequest(Prev, New, TrUserData);
      #'AuthReply'{} ->
	  merge_msg_AuthReply(Prev, New, TrUserData)
    end.

merge_msg_AuthRequest(#'AuthRequest'{auth_type =
					 PFauth_type,
				     username = PFusername,
				     password = PFpassword},
		      #'AuthRequest'{auth_type = NFauth_type,
				     username = NFusername,
				     password = NFpassword},
		      _) ->
    #'AuthRequest'{auth_type =
		       if NFauth_type =:= undefined -> PFauth_type;
			  true -> NFauth_type
		       end,
		   username =
		       if NFusername =:= undefined -> PFusername;
			  true -> NFusername
		       end,
		   password =
		       if NFpassword =:= undefined -> PFpassword;
			  true -> NFpassword
		       end}.

merge_msg_AuthReply(#'AuthReply'{reply_type =
				     PFreply_type},
		    #'AuthReply'{reply_type = NFreply_type}, _) ->
    #'AuthReply'{reply_type =
		     if NFreply_type =:= undefined -> PFreply_type;
			true -> NFreply_type
		     end}.


verify_msg(Msg) -> verify_msg(Msg, []).

verify_msg(Msg, Opts) ->
    TrUserData = proplists:get_value(user_data, Opts),
    case Msg of
      #'AuthRequest'{} ->
	  v_msg_AuthRequest(Msg, ['AuthRequest'], TrUserData);
      #'AuthReply'{} ->
	  v_msg_AuthReply(Msg, ['AuthReply'], TrUserData);
      _ -> mk_type_error(not_a_known_message, Msg, [])
    end.


-dialyzer({nowarn_function,v_msg_AuthRequest/3}).
v_msg_AuthRequest(#'AuthRequest'{auth_type = F1,
				 username = F2, password = F3},
		  Path, _) ->
    if F1 == undefined -> ok;
       true -> v_enum_AuthRequestType(F1, [auth_type | Path])
    end,
    if F2 == undefined -> ok;
       true -> v_type_string(F2, [username | Path])
    end,
    if F3 == undefined -> ok;
       true -> v_type_string(F3, [password | Path])
    end,
    ok.

-dialyzer({nowarn_function,v_msg_AuthReply/3}).
v_msg_AuthReply(#'AuthReply'{reply_type = F1}, Path,
		_) ->
    if F1 == undefined -> ok;
       true -> v_enum_AuthReplyType(F1, [reply_type | Path])
    end,
    ok.

-dialyzer({nowarn_function,v_enum_AuthRequestType/2}).
v_enum_AuthRequestType('LOGIN', _Path) -> ok;
v_enum_AuthRequestType('LOGOUT', _Path) -> ok;
v_enum_AuthRequestType(V, Path) when is_integer(V) ->
    v_type_sint32(V, Path);
v_enum_AuthRequestType(X, Path) ->
    mk_type_error({invalid_enum, 'AuthRequestType'}, X,
		  Path).

-dialyzer({nowarn_function,v_enum_AuthReplyType/2}).
v_enum_AuthReplyType('OK', _Path) -> ok;
v_enum_AuthReplyType('WRONG_USER', _Path) -> ok;
v_enum_AuthReplyType('WRONG_PASSWORD', _Path) -> ok;
v_enum_AuthReplyType('NOT_OK', _Path) -> ok;
v_enum_AuthReplyType('NOT_LOGGED_IN', _Path) -> ok;
v_enum_AuthReplyType(V, Path) when is_integer(V) ->
    v_type_sint32(V, Path);
v_enum_AuthReplyType(X, Path) ->
    mk_type_error({invalid_enum, 'AuthReplyType'}, X, Path).

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
    [{{enum, 'AuthRequestType'},
      [{'LOGIN', 0}, {'LOGOUT', 1}]},
     {{enum, 'AuthReplyType'},
      [{'OK', 0}, {'WRONG_USER', 1}, {'WRONG_PASSWORD', 2},
       {'NOT_OK', 3}, {'NOT_LOGGED_IN', 4}]},
     {{msg, 'AuthRequest'},
      [#field{name = auth_type, fnum = 1, rnum = 2,
	      type = {enum, 'AuthRequestType'}, occurrence = optional,
	      opts = []},
       #field{name = username, fnum = 2, rnum = 3,
	      type = string, occurrence = optional, opts = []},
       #field{name = password, fnum = 3, rnum = 4,
	      type = string, occurrence = optional, opts = []}]},
     {{msg, 'AuthReply'},
      [#field{name = reply_type, fnum = 1, rnum = 2,
	      type = {enum, 'AuthReplyType'}, occurrence = optional,
	      opts = []}]}].


get_msg_names() -> ['AuthRequest', 'AuthReply'].


get_group_names() -> [].


get_msg_or_group_names() ->
    ['AuthRequest', 'AuthReply'].


get_enum_names() ->
    ['AuthRequestType', 'AuthReplyType'].


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


find_msg_def('AuthRequest') ->
    [#field{name = auth_type, fnum = 1, rnum = 2,
	    type = {enum, 'AuthRequestType'}, occurrence = optional,
	    opts = []},
     #field{name = username, fnum = 2, rnum = 3,
	    type = string, occurrence = optional, opts = []},
     #field{name = password, fnum = 3, rnum = 4,
	    type = string, occurrence = optional, opts = []}];
find_msg_def('AuthReply') ->
    [#field{name = reply_type, fnum = 1, rnum = 2,
	    type = {enum, 'AuthReplyType'}, occurrence = optional,
	    opts = []}];
find_msg_def(_) -> error.


find_enum_def('AuthRequestType') ->
    [{'LOGIN', 0}, {'LOGOUT', 1}];
find_enum_def('AuthReplyType') ->
    [{'OK', 0}, {'WRONG_USER', 1}, {'WRONG_PASSWORD', 2},
     {'NOT_OK', 3}, {'NOT_LOGGED_IN', 4}];
find_enum_def(_) -> error.


enum_symbol_by_value('AuthRequestType', Value) ->
    enum_symbol_by_value_AuthRequestType(Value);
enum_symbol_by_value('AuthReplyType', Value) ->
    enum_symbol_by_value_AuthReplyType(Value).


enum_value_by_symbol('AuthRequestType', Sym) ->
    enum_value_by_symbol_AuthRequestType(Sym);
enum_value_by_symbol('AuthReplyType', Sym) ->
    enum_value_by_symbol_AuthReplyType(Sym).


enum_symbol_by_value_AuthRequestType(0) -> 'LOGIN';
enum_symbol_by_value_AuthRequestType(1) -> 'LOGOUT'.


enum_value_by_symbol_AuthRequestType('LOGIN') -> 0;
enum_value_by_symbol_AuthRequestType('LOGOUT') -> 1.

enum_symbol_by_value_AuthReplyType(0) -> 'OK';
enum_symbol_by_value_AuthReplyType(1) -> 'WRONG_USER';
enum_symbol_by_value_AuthReplyType(2) ->
    'WRONG_PASSWORD';
enum_symbol_by_value_AuthReplyType(3) -> 'NOT_OK';
enum_symbol_by_value_AuthReplyType(4) ->
    'NOT_LOGGED_IN'.


enum_value_by_symbol_AuthReplyType('OK') -> 0;
enum_value_by_symbol_AuthReplyType('WRONG_USER') -> 1;
enum_value_by_symbol_AuthReplyType('WRONG_PASSWORD') ->
    2;
enum_value_by_symbol_AuthReplyType('NOT_OK') -> 3;
enum_value_by_symbol_AuthReplyType('NOT_LOGGED_IN') ->
    4.


get_service_names() -> [].


get_service_def(_) -> error.


get_rpc_names(_) -> error.


find_rpc_def(_, _) -> error.



-spec fetch_rpc_def(_, _) -> no_return().
fetch_rpc_def(ServiceName, RpcName) ->
    erlang:error({no_such_rpc, ServiceName, RpcName}).


get_package_name() -> auth.



gpb_version_as_string() ->
    "4.1.1".

gpb_version_as_list() ->
    [4,1,1].
