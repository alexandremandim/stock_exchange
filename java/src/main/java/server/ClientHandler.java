package server;


import Utils.adresses.HostPort;
import Utils.requests.CompanyDB;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import protobuf.auth.Auth;
import protobuf.order.Order;
import protobuf.pdus.Pdu;

import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;

/**
 * Classe para tratar pedidos de um cliente
 */
public class ClientHandler extends Thread{

    private Socket socket;          // Socket do cliente
    private UsersDB usersDB;        // Referencia para a base de dados dos users
    private CompanyDB companyDB;    // Referencia para a base de dados das empresas

    public final static Logger logger = LoggerFactory.getLogger(ClientHandler.class);

    public ClientHandler(){}

    public ClientHandler(Socket socket, UsersDB usersDB, CompanyDB companyDB) {
        this.socket = socket;
        this.usersDB = usersDB;
        this.companyDB = companyDB;
    }

    @Override
    public void run() {

        try {
            while(socket.isConnected()) {
                InputStream in = socket.getInputStream();
                Pdu.PduFromClient pdu = Pdu.PduFromClient.parseDelimitedFrom(in);

                /**
                 * A mensagem PDU no .proto é do tipo oneof.
                 * Com getRequestCase pode-se saber qual dos "oneof"
                 * foi enviado na mensagem.
                 */
                switch (pdu.getRequestCase()) {
                    case AUTH:
                        Auth.AuthRequest auth = pdu.getAuth();
                        trataAuth(auth);
                        break;
                    case ORDER:
                        Order.OrderRequestData order = pdu.getOrder();
                        trataOrder(order);
                        break;
                    case REQUEST_NOT_SET:
                        logger.info("Request nao definido");
                        break;
                    default:
                        logger.warn("Caso default ao receber pedido do cliente.");
                        break;
                }
            }

        } catch (IOException e) {
            logger.error(e.getMessage());
        } finally {
            // Quer tenha havido ou nao excepcoes, tentar fechar o scoket.
            try {
                socket.close();
            } catch (IOException e) {
                logger.error("Erro a fechar socket: " + e.getMessage());
            }
        }

    }

    /**
     * Trata pedidos de autenticacao
     */
    public void trataAuth(Auth.AuthRequest auth){

        String username = auth.getUsername();
        String password = auth.getPassword();

        switch(auth.getAuthType()){
            case LOGIN:

                /**
                 * Define tipo de resposta a mandar ao cliente consoante
                 * a informacao de autenticacao ser ou nao valida
                 */
                if(usersDB.userExists(username)){
                    if(usersDB.verifyPassword(username, password)){
                        sendAuthReply(Auth.AuthReplyType.OK);
                        usersDB.login(username);
                    } else{
                        sendAuthReply(Auth.AuthReplyType.WRONG_PASSWORD);
                    }
                }else{
                    sendAuthReply(Auth.AuthReplyType.WRONG_USER);
                }
                break;
            case LOGOUT:
                if(usersDB.isLoggedIn(username)){
                    usersDB.logout(username);
                    sendAuthReply(Auth.AuthReplyType.OK);
                } else {
                    sendAuthReply(Auth.AuthReplyType.NOT_LOGGED_IN);
                }

                logger.info("User " + username + " fez logout.");
                break;
            case UNRECOGNIZED:
                logger.info("Pedido nao reconhecido");
                break;
            default:
                logger.warn("Caso default ao receber pedido de cliente");

        }
    }

    /**
     * Trata de pedidos de compra e venda de accoes
     */
    public void trataOrder(Order.OrderRequestData order){
        String username = order.getUsername();

        if(!usersDB.isLoggedIn(username)){
            /**
             * O utilizador não tem login feito, enviar resposta e sair.
             */
            sendOrderReply(Order.OrderReplyType.NOT_LOGGED_IN);
            return;
        }

        // Ve a empresa que o utilizador indicou na mensagem
        String empresa = order.getCompany();

        /**
         * Define resposta a enviar ao cliente
         */
        if(companyDB.companyExists(empresa)){
            sendOrderReply(Order.OrderReplyType.OK);
        } else{
            sendOrderReply(Order.OrderReplyType.INVALID_COMPANY);
        }


        // Verifica endereco da exchange em que a empresa é negociada
        HostPort hp = new HostPort(companyDB.getCompanySAddress(empresa));

        /**
         * Abre socket e contacta exchange. O pedido enviado
         * é o mesmo que o que foi recebido.
         *
         * NOTA: Talvez seja melhor criar previamente os sockets
         * para contactar exchange?
         */
        try {
            Socket socketExchange = new Socket(hp.getHost(),hp.getPort());
            order.writeDelimitedTo(socketExchange.getOutputStream());
            socketExchange.close();
        } catch (IOException e) {
            logger.error("Erro ao contactar exchange: " + e.getMessage());
        }

    }

    /**
     * A resposta apenas tem um campo, o tipo de resposta.
     * Esta função envia a resposta para o cliente no socket
     * recebendo apenas o tipo de resposta que se quer enviar.
     */
    public void sendAuthReply(Auth.AuthReplyType replyType){
        Auth.AuthReply reply = Auth.AuthReply.newBuilder()
                .setReplyType(replyType)
                .build();
        try {
            reply.writeDelimitedTo(socket.getOutputStream());
        } catch (IOException e) {
            logger.error("Erro ao obter socket de escrita: " + e.getMessage());
        }

    }

    public void sendOrderReply(Order.OrderReplyType replyType){
        Order.OrderReplyData reply = Order.OrderReplyData.newBuilder()
                                    .setReplyType(replyType)
                                    .build();
        try {
            reply.writeDelimitedTo(socket.getOutputStream());
        } catch (IOException e) {
            logger.error("Erro ao obter socket de escrita: " + e.getMessage());
        }

    }

}
