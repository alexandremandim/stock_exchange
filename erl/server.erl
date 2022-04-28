-module(server).
-compile(export_all).
-include("pdu.hrl").
-include("auth.hrl").
-include("order.hrl").
-import(login_manager, [start/0]).
-import(supervisor, [init/0]).

start(LPort) ->
    %registando os processos de login e de repositorio das empresas
    register(manager ,spawn(fun()-> login_manager:start() end)),
    register(empresa_rep, spawn(fun()-> ?MODULE:empresas_repository(#{}) end)),

    Empresa = spawn(fun()-> room_empresas(#{}) end),
    Empresa ! {get_mapa},
    manager ! {{create_account, "renato", "renato"}, self()},
    manager ! {{create_account, "alex", "alex"}, self()},
    manager ! {{create_account, "andre", "andre"}, self()},
    
    case gen_tcp:listen(LPort,[{active, false},{packet,2}]) of
        {ok, ListenSock} ->
	          acceptor(ListenSock);    
        {error,Reason} ->
            {error,Reason}
    end.

acceptor(LSock) ->
  {ok, Sock} = gen_tcp:accept(LSock),
  spawn(fun() -> acceptor(LSock) end),
  user(Sock).



user(S) ->
    inet:setopts(S,[{packet, 1},{active,once}, binary]),
    io:format("[Server] Esperando pedido!~n"),
    %gen_tcp:recv(S, 0),
    receive
        {tcp,S,Data} ->
            io:format("Data received~n"),
            {'PduFromClient',Pedido} = pdu:decode_msg(Data, 'PduFromClient'),
            case Pedido of
              {auth,{'AuthRequest','LOGIN',Nome,Pass}} ->
                  manager ! {{login, Nome, Pass}, self()},
                  receive
                    {ok, user_login} ->
                      io:format("[Server][Login] User login sucessful~n"),
                      Reply = auth:encode_msg(#'AuthReply'{reply_type=0}),
                      gen_tcp:send(S, Reply);
                    {error, no_user} ->
                      io:format("[Server][Login] User does not exist~n"),
                      Reply = auth:encode_msg(#'AuthReply'{reply_type=1}),
                      gen_tcp:send(S, Reply);
                    {error, wrong_password} ->
                      io:format("[Server][Login] Wrong password~n"),
                      Reply = auth:encode_msg(#'AuthReply'{reply_type=2}),
                      gen_tcp:send(S, Reply)
                  end; 

              {auth,{'AuthRequest','LOGOUT',Nome,Pass}} ->
                  io:format("logout~n"),
                  manager ! {{logout, Nome, Pass}, self()},
                  receive
                    {ok, user_logout} ->
                      io:format("[Server][Logout] User logout sucessful~n"),
                      Reply = auth:encode_msg(#'AuthReply'{reply_type=0}),
                      gen_tcp:send(S, Reply);
                    {error, no_user} ->
                      io:format("[Server][Logout] User does not exist~n"),
                      Reply = auth:encode_msg(#'AuthReply'{reply_type=1}),
                      gen_tcp:send(S, Reply)
                  end;

              {order,{'OrderRequestData','BUY',Empresa, Qtd,Price,Username}} ->
                  manager ! {{is_login, Username}, self()},
                  receive
                    {error, no_user} -> 
                        Reply = order:encode_msg(#'OrderReplyData'{reply_type=1}),
                        gen_tcp:send(S, Reply);
                    {ok, no_login} ->
                        Reply = order:encode_msg(#'OrderReplyData'{reply_type=3}),
                        gen_tcp:send(S, Reply);
                    {ok, user_login} ->
                        io:format("Buy Request~n"),               
                        empresa_rep ! {get_exchange, Empresa, self()},
                        receive
                            {error} ->
                              Reply = order:encode_msg(#'OrderReplyData'{reply_type=2}),
                              gen_tcp:send(S, Reply);
                              
                            {ok, ExchangeAddr} ->
                              
                              Address = list_to_integer(lists:last(string:split(ExchangeAddr, ":"))),
                              {ok,ExchangeSock} = gen_tcp:connect("localhost", Address, [binary, {packet, 1}]),
                              gen_tcp:send(ExchangeSock, order:encode_msg(#'OrderRequestData'{order_type=0,company=Empresa,qtd=Qtd,price=Price, username=Username})),
                              ok = gen_tcp:close(ExchangeSock),
                              Reply = order:encode_msg(#'OrderReplyData'{reply_type=0}),
                              gen_tcp:send(S, Reply)

                        end 


                  end;
                                 
              {order,{'OrderRequestData','SELL',Empresa, Qtd,Price, Username}} ->

                %verificar se está logged in
                manager ! {{is_login, Username}, self()},
                receive
                    {error, no_user} ->
                        Reply = order:encode_msg(#'OrderReplyData'{reply_type=1}),
                        gen_tcp:send(S, Reply);
                    {ok, no_login} ->
                        Reply = order:encode_msg(#'OrderReplyData'{reply_type=3}),
                        gen_tcp:send(S, Reply);
                    {ok, user_login} ->
                      io:format("Sell Request~n"),
                      empresa_rep ! {get_exchange, Empresa, self()},
                      receive
                          {error} ->
                            Reply = order:encode_msg(#'OrderReplyData'{reply_type=2}),
                            gen_tcp:send(S, Reply);
                            
                          {ok, ExchangeAddr} ->
                            
                            Address = list_to_integer(lists:last(string:split(ExchangeAddr, ":"))),
                            {ok,ExchangeSock} = gen_tcp:connect("localhost", Address, [binary, {packet, 1}]),
                            gen_tcp:send(ExchangeSock, order:encode_msg(#'OrderRequestData'{order_type=1,company=Empresa,qtd=Qtd,price=Price, username=Username})),
                            ok = gen_tcp:close(ExchangeSock),
                            Reply = order:encode_msg(#'OrderReplyData'{reply_type=0}),
                            gen_tcp:send(S, Reply)

                      end
                end




                   
            end,
            io:format("got message: ~p~n", [Pedido]),

            user(S);
        {tcp_closed,S} ->
            io:format("Socket ~w closed [~w]~n",[S,self()]),
            ok
    end.



room_empresas(M) ->
  receive
  {ok, Empresa} ->
      room_empresas(M);

  {get_mapa} ->
      
      inets:start(),
        {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} = httpc:request("http://127.0.0.1:8080/empresas"),
          
          L = jiffy:decode(Body, [return_maps]),
          lists:foreach(fun(X) -> 
            N = binary_to_list(maps:get(<<"name">>,X)), 
            C = binary_to_list(maps:get(<<"clientaddr">>,X)),
            S = binary_to_list(maps:get(<<"servidoraddr">>,X)),
            K = maps:put(N, {C,S}, M),
            empresa_rep ! {ok, K}
             end, L),  
      room_empresas(M)
  end.




empresas_repository(Rep) ->
  receive
    {ok, M} ->
      Nm = maps:merge(M,Rep),
      io:format("[Repositorio de empresas]~p~n", [Nm]),
      empresas_repository(Nm);

    {get_exchange, Empresa, From} ->
      case maps:find(Empresa,Rep) of
        error ->
          From ! {error},
          empresas_repository(Rep);

        {ok, {ClientAddr, ExchangeAddr}} ->
          From ! {ok, ExchangeAddr},
          empresas_repository(Rep) 
      end
  end.




  %inet:setopts(Sock,[{packet, 1},{active,once}, binary]),
                  %receive
                    %{tcp,Sock,Coisas} ->
                    %  io:format("[Server][Buy] Response~n");
                    %{tcp_closed,Sock} ->
                    %  io:format("[Server][Buy] Error Response~n")

                 % end;
