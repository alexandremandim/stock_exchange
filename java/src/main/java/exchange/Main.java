package exchange;

import Utils.requests.Requests;
import exchange.args.ParsedArguments;
import exchange.args.Parser;
import joptsimple.OptionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.ServerSocket;
import java.net.Socket;

public class Main {

    public final static Logger logger = LoggerFactory.getLogger(Main.class);
    public static ParsedArguments arguments;
    public static Exchange exchange;


    public static void main(String[] args) {
        // Le e trata argumentos passados ao programa
        arguments = readArguments(args);
        logger.info(arguments.toString());
        // Inicializa exchange
        init();
        // Espera e atender pedidos do servidor
        serverLoop();
    }

    public static void serverLoop(){

        try {
            ServerSocket serverSocket = new ServerSocket(arguments.getServerPort());
            boolean sair = false;

            while (!sair) {

                try {
                    Socket socket = serverSocket.accept();

                    ServerHandler serverHandler = new ServerHandler(socket, exchange);
                    serverHandler.start();

                } catch (IOException e) {
                    logger.error("Excepção à espera de conexões: " + e.getMessage());
                    sair = true;
                }
            }

            serverSocket.close();
        } catch (IOException e) {
            logger.error("Erro ao abrir server socket na porta " + arguments.getServerPort() + ": " + e.getMessage());
        }


    }

    /**
     * Inicializa exchange notificando o directorio das empresas que estão
     * a ser servidas por esta exchange e inicializando uma instancia
     * de Exchange, que contém a informação de estado.
     */
    public static void init(){
        notifyDirectory();
        exchange = new Exchange(arguments.getCompanies());
    }

    /**
     * Notifica o directorio das empresas que esta exchange serve
     * através do método POST da API do directorio.
     */
    public static void notifyDirectory(){
        String directory = arguments.getDirectoryBaseUrl().getHost();

        String baseUrl = "http://" + directory + "/empresas";

        for(String empresa: arguments.getCompanies()){
            try {
                Requests.put(baseUrl + "?empresa=" + empresa + "&clientaddr=localhost:" + arguments.getPublishPort()
                                + "&servidoraddr=localhost:"+arguments.getServerPort());
            } catch (MalformedURLException e) {
                logger.error("Url mal formado, nao foi possivel adicionar a empresa " + empresa + " ao directorio.");
            }
        }

    }

    /**
     * Le e trata argumentos passados ao programa
     */
    public static ParsedArguments readArguments(String[] args) {
        ParsedArguments res = null;
        try {
            res = Parser.parse(args);
        } catch (MalformedURLException ex) {
            logger.error("Url do directorio malformado: " + ex.getMessage());
            logger.error("A sair do programa.");
            System.exit(0);
        } catch (OptionException ex) {
            logger.error("Erro nas opções do programa: " + ex.getMessage());
            logger.error("A sair do programa.");
            System.exit(0);
        }
        return res;
    }
}
