-module(login_manager).
-export([start/0,create_account/2, close_account/2, login/2, logout/1, online/0]).



%create_account(U,P) -> ok | user_exists
%close_account(U,P) -> ok | invalid
%login(U,P) -> ok | invalid
%logout(U -> ok

%online()-> [username]



rpc(Request) ->
	?MODULE ! {Request,self()},
	receive {?MODULE, Res} -> Res end.


create_account(U,P) -> rpc({create_account, U,P}).
close_account(U,P) -> rpc({close_account, U,P}).
login(U,P) -> rpc({login, U,P}).
logout(U) -> rpc({logout, U}).
online() -> rpc(online).

%create_account(U,P) ->
%	?MODULE ! {create_account, U, P,self()},
%	receive {?MODULE, Res} -> Res end. 

%close_account(U,P) -> 
%	?MODULE ! {close_account, U,P, self()}.
%	receive {?MODULE, Res} -> Res end.


%começa o propiro module
start() ->
	io:format("[Manager] Manager server is up and running!~n"),
	%register(?MODULE, spawn(fun() -> loop(#{}) end)).
	loop(#{}).

loop(M) ->
	receive
		{{create_account, U, P}, From} ->
			%io:format("[Manager] Creating account!~n"),
			case maps:find(U,M) of
				error -> 
					From ! {?MODULE, ok},
					io:format("[Manager] Account created!~n"),
					loop(maps:put(U,{P, false},M));
					
				_ -> 	
					From ! {?MODULE, user_exists},
					io:format("[Manager] User already exists!~n"),
					loop(M)
			end;
		{{login, U, P}, From} ->
			case maps:find(U,M) of
				error ->
				  From ! {error, no_user},
				  io:format("[Manager] User does not exist!~n"),
				  loop(M);

				_ -> 
					case maps:get(U,M) of

						{P, true} ->
							io:format("[Manager] Already logged in! ~n"),
							From ! {ok, user_login},
							loop(M);
						{P, false} ->
							io:format("[Manager] Login done! ~n"),
							From ! {ok, user_login},
							loop(maps:put(U,{P, true},M));
						{_,_} -> 
							io:format("[Manager] Login done! ~n"),
							From ! {error, wrong_password},
							loop(M)


					end					  
			end;

		{{is_login,U}, From} ->
			case maps:find(U,M) of
				error ->
				  From ! {error, no_user},
				  io:format("[Manager] User does not exist!~n"),
				  loop(M);

				_ -> 
					case maps:get(U,M) of

						{_, true} ->
							io:format("[Manager] Already logged in! ~n"),
							From ! {ok, user_login},
							loop(M);
						{_, false} ->
							io:format("[Manager] User not logged in! ~n"),
							From ! {ok, no_login},
							loop(M)
					end					  
			end;


				
		{{logout, U, P}, From} ->
			case maps:find(U,M) of
				error ->
				  From ! {error, no_user},
				  io:format("[Manager] User does not exist!~n"),
				  loop(M);
				_ ->
					case maps:get(U,M) of

						{P, true} ->
							io:format("[Manager] Logout completed! ~n"),
							From ! {ok, user_logout},
							loop(maps:update(U,{P, false},M));
							%loop(M);
						{P , false} ->
							io:format("[Manager] User not logged in! ~n"),
							From ! {ok, user_logout},
							loop(M)
					end	
				

			end;


		{{close_account, U, P}, From} ->
			case maps:find(U,M) of
				{ok,{P,_}}->
					From ! {?MODULE, ok},
					loop(maps:remove(U,M));
				_ ->
					From ! {?MODULE, invalid},
					loop(M)
			end;

		{{online}, From} ->
			Res = [User || {User,{_Pass,true}} <- maps:to_list(M)],
			From ! {?MODULE, Res},
			loop(M)

	end.
