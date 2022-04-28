package client;


import Utils.requests.CompanyDB;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.zeromq.ZMQ;
import protobuf.auth.Auth;
import protobuf.order.Order;
import protobuf.pdus.Pdu;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URL;
import java.util.ArrayList;


/**
 * Principal classe de gestão do cliente.
 * Gere os sockets, base de dados de empresas e controla estado
 * relativo ao login do utilizador.
 */
public class Session extends Thread{

    private String username;        // Username do utilizador (caso esteja loggado)
    private String password;        // Username do utilizador, importante para autenticacao
    private boolean logged_in;      // O utilizador ja fez login?
    private boolean quit_session;   // A sessao deve ser abandonada?
    private Socket serverSocket;    // Socket de ligacao ao servidor
    private URL directoryBaseUrl;   // Endereco do directorio
    private CompanyDB companyDB;    // Base de dados das empresas, com a associacao
                                    // nome - (endereco,porta)

    ZMQ.Context context;
    ZMQ.Socket socket;
    // Gestor de logs da sessao
    public final static Logger logger = LoggerFactory.getLogger(Session.class);

    ArrayList<String> subs = new ArrayList<>();


    @Override
    public void run() {
        System.out.println("Thread running");
        while(!Thread.currentThread().isInterrupted()) {
            String address = new String(socket.recv(0));
            System.out.println(address);
        }
    }


    /**
     * Inicia variáveis de sessao e socket de ligacao ao servidor.
     */
    public Session(InetSocketAddress serverAddr,
                   URL directoryBaseUrl,
                   CompanyDB companyDB) throws IOException {
        this.logged_in = false;
        this.username = null;
        this.password = null;
        this.quit_session = false;
        this.serverSocket = new Socket(serverAddr.getAddress(), serverAddr.getPort());
        this.directoryBaseUrl = directoryBaseUrl;
        this.companyDB = companyDB;
        this.context = ZMQ.context(1);
        this.socket = context.socket(ZMQ.SUB);
        socket.connect("tcp://*:22222");
        //socket.subscribe("ctt".getBytes());
        new Thread(this).start();

    }

    /**
     * Regista acto de login.
     */
    public synchronized void registerLogin(String username, String password){
        logged_in = true;
        this.username = username;
        this.password = password;
    }

    /**
     * Regista acto de logout.
     */
    public synchronized void logout(){
        logged_in = false;
        this.username = null;
        this.password = null;
    }

    public synchronized String getUsername() {
        return username;
    }

    public synchronized boolean isLoggedIn() {
        return logged_in;
    }

    public synchronized boolean readyToQuit() {
        return quit_session;
    }

    public synchronized void markReadyToQuit(){
        quit_session = true;
    }

    public synchronized void closeSession() throws IOException {
        serverSocket.close();
    }




    public synchronized void subscribe(String empresa){
        if(subs.contains(empresa)){
            logger.info("Já tem esta subscrição na sua lista.");
        }else{
            socket.subscribe(empresa.getBytes());
            subs.add(empresa);
            logger.info("Subscricão efectuada.");
        }


    }

    public synchronized void unsubscribe(String empresa){
        if(subs.contains(empresa)){
            socket.unsubscribe(empresa.getBytes());
            subs.remove(empresa);
            logger.info("Subscricão removida.");
        }else{
            logger.info("Não está subscrito a esta empresa.");
        }


    }

    /**
     * Envia pedido de login ao servidor e espera por resposta.
     */
    public synchronized void sendLogin(String user, String pass) throws IOException {

        OutputStream out = serverSocket.getOutputStream();
        Auth.AuthRequest auth = Auth.AuthRequest.newBuilder()
                                        .setAuthType(Auth.AuthRequestType.LOGIN)
                                        .setUsername(user)
                                        .setPassword(pass)
                                        .build();

        Pdu.PduFromClient pdu = Pdu.PduFromClient.newBuilder()
                                .setAuth(auth)
                                .build();

        pdu.writeDelimitedTo(out);
        logger.info("Login sent");
        out.flush();

        InputStream in = serverSocket.getInputStream();
        Auth.AuthReply resposta = Auth.AuthReply.parseDelimitedFrom(in);

        switch(resposta.getReplyType()){
            case OK:
                username = user;
                password = pass;
                logged_in = true;
                logger.info("Bem vindo, " + username);
                break;
            case WRONG_PASSWORD:
                logger.info("Password errada");
                break;
            case WRONG_USER:
                logger.info("Utilizador não existe");
                break;
            case NOT_OK:
                logger.info("Login failed.");
                break;
            case UNRECOGNIZED:
                logger.info("Tipo de resposta nao reconhecido (campo UNRECOGNIZED)");
                break;
            case NOT_LOGGED_IN:
                logger.info("Esta operação requer login.");
            default:
                logger.info("Tipo de resposta nao reconhecido");
                break;
        }
    }

    /**
     * Envia pedido de venda de accoes ao servidor e espera por resposta.
     */
    public synchronized void sendSellOrder(String empresa,
                                           int amount,
                                           int min_price) throws IOException {

        OutputStream out = serverSocket.getOutputStream();
        Order.OrderRequestData order = Order.OrderRequestData.newBuilder()
                .setOrderType(Order.OrderRequestType.SELL)
                .setCompany(empresa)
                .setQtd(amount)
                .setPrice(min_price)
                .setUsername(username)
                .build();

        Pdu.PduFromClient pdu = Pdu.PduFromClient.newBuilder()
                .setOrder(order)
                .build();

        pdu.writeDelimitedTo(out);

        InputStream in = serverSocket.getInputStream();
        Order.OrderReplyData resposta = Order.OrderReplyData.parseDelimitedFrom(in);

        switch(resposta.getReplyType()){
            case OK:
                logger.info("Ordem de venda inserida com sucesso.");
                break;
            case NOT_OK:
                logger.info("Ordem de venda não inserida.");
                break;
            case NOT_LOGGED_IN:
                logger.info("Esta operação requer login");
                break;
            case INVALID_COMPANY:
                logger.info("Esta empresa não existe.");
                break;
            case UNRECOGNIZED:
                logger.info("Tipo de resposta nao reconhecido (campo UNRECOGNIZED)");
                break;
            default:
                logger.info("Tipo de resposta nao reconhecido");
                break;
        }
    }

    /**
     * Envia pedido de compra de accoes ao servidor e espera por resposta.
     */
    public synchronized void sendBuyOrder(String empresa,
                                           int amount,
                                           int max_price) throws IOException {

        OutputStream out = serverSocket.getOutputStream();
        Order.OrderRequestData order = Order.OrderRequestData.newBuilder()
                .setOrderType(Order.OrderRequestType.BUY)
                .setCompany(empresa)
                .setQtd(amount)
                .setPrice(max_price)
                .setUsername(username)
                .build();

        Pdu.PduFromClient pdu = Pdu.PduFromClient.newBuilder()
                .setOrder(order)
                .build();

        pdu.writeDelimitedTo(out);

        InputStream in = serverSocket.getInputStream();
        Order.OrderReplyData resposta = Order.OrderReplyData.parseDelimitedFrom(in);

        switch(resposta.getReplyType()){
            case OK:
                logger.info("Ordem de compra inserida com sucesso.");
                break;
            case NOT_OK:
                logger.info("Ordem de compra não inserida.");
                break;
            case NOT_LOGGED_IN:
                logger.info("Esta operação requer login");
                break;
            case INVALID_COMPANY:
                logger.info("Esta empresa não existe.");
                break;
            case UNRECOGNIZED:
                logger.info("Tipo de resposta nao reconhecido (campo UNRECOGNIZED)");
                break;
            default:
                logger.info("Tipo de resposta nao reconhecido");
                break;
        }
    }

    /**
     * Envia pedido de logout ao servidor e espera por resposta
     * Este pedido serve apenas para o cliente informar o servidor
     * que pretende fazer logout.
     * O servidor podera querer (ou nao) fazer algo com essa informacao.
     */
    public synchronized void sendLogout() throws IOException {

        if(logged_in){
            /**
             * Apenas envia mensagem de logout se o utilizador
             * tiver feito login
             */
            OutputStream out = serverSocket.getOutputStream();
            Auth.AuthRequest auth = Auth.AuthRequest.newBuilder()
                    .setAuthType(Auth.AuthRequestType.LOGOUT)
                    .setUsername(username)
                    .setPassword(password)
                    .build();

            Pdu.PduFromClient pdu = Pdu.PduFromClient.newBuilder()
                                    .setAuth(auth)
                                    .build();

            pdu.writeDelimitedTo(out);
            InputStream in = serverSocket.getInputStream();
            Auth.AuthReply resposta = Auth.AuthReply.parseDelimitedFrom(in);

            switch(resposta.getReplyType()){
                case OK:
                    logged_in=false;
                    logger.info("Adeus, " + username);
                    break;
                case NOT_OK:
                    logger.info("Logout failed.");
                    break;
                case UNRECOGNIZED:
                    logger.info("Tipo de resposta nao reconhecido (campo UNRECOGNIZED)");
                    break;
                case NOT_LOGGED_IN:
                    logger.info("Esta operação requer login");
                    break;
                default:
                    logger.info("Tipo de resposta nao reconhecido");
                    break;
            }
        }
    }





}
