package server;

import Utils.requests.Company;
import Utils.requests.CompanyDB;
import Utils.requests.JsonToObjects;
import joptsimple.OptionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import server.args.ParsedArguments;
import server.args.Parser;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Map;

public class Main {

    public final static Logger logger = LoggerFactory.getLogger(Main.class);
    public static CompanyDB companyDB;
    public static UsersDB usersDB;
    public static ParsedArguments arguments;

    public static void main(String[] args) {
        // Le e trata argumentos passados ao programa
        arguments = readArguments(args);
        logger.info(arguments.toString());
        // Inicializa base de dados de empresas e users
        init();
    }

    public static void serverLoop() {
        try {
            ServerSocket serverSocket = new ServerSocket(arguments.getPort());
            boolean sair = false;

            while (!sair) {

                try {
                    Socket socket = serverSocket.accept();
                    ClientHandler clientHandler = new ClientHandler(socket, usersDB, companyDB);
                    clientHandler.start();

                } catch (IOException e) {
                    logger.error("Excepção à espera de conexões: " + e.getMessage());
                    sair = true;
                }
            }

            serverSocket.close();
        } catch (IOException e) {
            logger.error("Erro ao abrir server socket na porta " + arguments.getPort() + ": " + e.getMessage());
        }


    }

    public static void init() {
        try {
            // Tenta obter informacao de empresas contactando o directorio
            Map<String, Company> empresas = JsonToObjects.getEmpresas(arguments.getDirectoryBaseUrl());
            companyDB = new CompanyDB(empresas);
            logger.info("Base de dados obtida de " + arguments.getDirectoryBaseUrl().getHost() + " com sucesso");
        } catch (MalformedURLException e) {
            // URL invalido, usa base de dados por defeito.
            logger.warn("Malformed URL:" + e.getMessage());
            logger.info("A usar base de dados por defeito.");
            companyDB = CompanyDB.getDefaultDB();
        }

        // Base de dados por defeito.
        usersDB = UsersDB.getDefaultDB();
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
