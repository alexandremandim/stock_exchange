package client;

import Utils.requests.Company;
import Utils.requests.CompanyDB;
import Utils.requests.JsonToObjects;
import client.args.ParsedArguments;
import client.args.Parser;
import joptsimple.OptionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.zeromq.ZMQ;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;

import java.util.Map;


public class Main{

    public final static Logger logger = LoggerFactory.getLogger(Main.class);
    public static ParsedArguments arguments;
    public static Session session;



    public static void main(String[] args) {

        // Trata argumentos da linha de comandos
        arguments = readArguments(args);
        logger.info(arguments.toString());

        // Inicia uma sessao
        session = initSession();

        //Le comandos do utilizador
        readCommandsLoop();
    }

    /**
     * Lê comandos que um utilizador escreve para interagir com o programa.
     * Podem ser usados os seguintes comandos:
     *
     * login <username> <password>
     * buy <company> <amount> <min_price>
     * sell <company> <amount> <max_price>
     * logout
     * quit
     */
    public static void readCommandsLoop(){

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;
        boolean quit = false;

        try {
            while(!quit && (line = reader.readLine()) != null){

                String command_args[] = line.split(" ");
                int nargs = command_args.length;

                switch(command_args[0]){
                    case "sub":
                        if(nargs != 2){
                            // Numero de argumentos errado, mostra mesagem ao utilizador
                            logger.info("Número de argumentos errado. Esperados: 1 | Encontrados: " + (nargs-1));
                            logger.info("\tExemplo: sub <empresa>");
                        } else{
                            // Numero de argumentos correcto, tenta enviar pedido de subscribe
                                session.subscribe(command_args[1]);
                        }

                        break;

                    case "unsub":
                        if(nargs != 2){
                            // Numero de argumentos errado, mostra mesagem ao utilizador
                            logger.info("Número de argumentos errado. Esperados: 1 | Encontrados: " + (nargs-1));
                            logger.info("\tExemplo: unsub <empresa>");
                        } else{
                            // Numero de argumentos correcto, tenta enviar pedido de subscribe
                            session.unsubscribe(command_args[1]);
                        }

                        break;
                    /**
                     * Pedido de login.
                     * Sintaxe: login <username> <password>
                     */
                    case "login":
                        if(nargs != 3){
                            // Numero de argumentos errado, mostra mesagem ao utilizador
                            logger.info("Número de argumentos errado. Esperados: 2 | Encontrados: " + (nargs-1));
                            logger.info("\tExemplo: login <username> <password>");
                        } else{
                            // Numero de argumentos correcto, tenta enviar pedido de login
                            try{
                                session.sendLogin(command_args[1], command_args[2]);
                            } catch (IOException ex){
                                logger.error("Erro ao enviar login");
                            }
                        }
                        break;
                    /**
                     * Pedido compra de accoes.
                     * Sintaxe: buy <company> <amount> <min_price>
                     */
                    case "buy":
                        if(nargs != 4){
                            // Numero de argumentos errado, mostra mesagem ao utilizador
                            logger.info("Número de argumentos errado. Esperados: 3 | Encontrados: " + (nargs-1));
                            logger.info("\tExemplo: buy <company> <amount> <min_price>");
                        } else{
                            // Numero de argumentos correcto, tenta enviar pedido
                            try {
                                int amount = Integer.parseInt(command_args[2]);
                                int max_price = Integer.parseInt(command_args[3]);
                                session.sendBuyOrder(command_args[1],amount,max_price);
                            } catch(NumberFormatException e){
                                logger.info("Erro ao converter argumentos para inteiros.");
                                logger.info("Nenhuma ordem foi enviada para o servidor.");
                            } catch (IOException ex){
                                logger.error("Erro ao enviar pedido de compra");
                            }

                        }
                        break;
                    /**
                     * Pedido venda de accoes.
                     * Sintaxe: sell <company> <amount> <max_price>
                     */
                    case "sell":
                        if(nargs != 4){
                            // Numero de argumentos errado, mostra mesagem ao utilizador
                            logger.info("Número de argumentos errado. Esperados: 3 | Encontrados: " + (nargs-1));
                            logger.info("\tExemplo: sell <company> <amount> <max_price>");
                        } else{
                            // Numero de argumentos correcto, tenta enviar pedido
                            try {
                                int amount = Integer.parseInt(command_args[2]);
                                int min_price = Integer.parseInt(command_args[3]);
                                session.sendSellOrder(command_args[1],amount,min_price);
                            } catch(NumberFormatException e){
                                logger.info("Erro ao converter argumentos para inteiros.");
                                logger.info("Nenhuma ordem foi enviada para o servidor.");
                            } catch (IOException ex){
                                logger.error("Erro ao enviar pedido de venda");
                            }

                        }
                        break;

                    /**
                     * Pedido venda de accoes.
                     * Sintaxe: logout
                     */
                    case "logout":
                        if(nargs != 1){
                            // Numero de argumentos errado, mostra mesagem ao utilizador
                            logger.info("Número de argumentos errado. Esperados: nenhum | Encontrados: " + (nargs-1));
                            logger.info("\tExemplo: logout");
                        } else{
                            // Numero de argumentos correcto, tenta enviar pedido se utilizador
                            // caso o utilizador tenha feito login
                            if(session.isLoggedIn()){
                                session.sendLogout();
                            }else{
                                logger.info("Why do you want to logout if you are not logged in? :)");
                            }

                        }
                        break;
                    /**
                     * Sai do programa.
                     *
                     */
                    case "quit":
                        quit=true;
                        break;
                    default:
                        logger.info("Comando nao reconhecido.");
                        break;
                }
            }
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } finally {
            // Quer tenham ou nao ocorrido excepcoes, tenta fechar sessao.
            try {
                session.closeSession();
            } catch (IOException e) {
                logger.error("Erro ao fechar sessao:" + e.getMessage());
            }
        }

    }

    /**
     * Le argumentos passados ao programa pela linha de comandos, trata-os
     * e devolve um ParsedArguments com os argumentos tratados para utilizacao
     * e acesso rapido no programa
     */

    public static ParsedArguments readArguments(String[] args){
        ParsedArguments res = null;
        try {
            res = Parser.parse(args);
        } catch (MalformedURLException ex) {
            logger.error("Url do directorio malformado: " + ex.getMessage());
            logger.error("A sair do programa.");
            System.exit(0);
        } catch (OptionException ex){
            logger.error("Erro nas opções do programa: " + ex.getMessage());
            logger.error("A sair do programa.");
            System.exit(0);
        }
        return res;
    }

    /**
     * Inicializa a informação das empresas (contactando o directorio)
     * e inicializa a "Sessao" que tem o estado do cliente e os sockets
     * de ligação ao servidor
     */
    public static Session initSession(){
        Session res = null;
        CompanyDB companyDB;

        try {
            /**
             * Contacta directorio para obter lista de empresas
             * Esta lista de emepresas esta agrupada na classe CompanyDB
             */
            Map<String, Company> empresas = JsonToObjects.getEmpresas(arguments.getDirectoryBaseUrl());
            companyDB = new CompanyDB(empresas);
            logger.info("Base de dados obtida de " + arguments.getDirectoryBaseUrl().getHost() + " com sucesso");
        } catch (MalformedURLException e) {
            /**
             * URL mal formado, em vez de tentar contactar o directorio,
             * usar uma base de dados de empresas por defeito,
             */
            logger.warn("Malformed URL:" + e.getMessage());
            logger.info("A usar base de dados por defeito.");
            companyDB = CompanyDB.getDefaultDB();
        }

        try {
            // Tenta começar uma nova sessao
            res = new Session(arguments.getServerAddress(),arguments.getDirectoryBaseUrl(),companyDB);
        } catch (IOException e) {
            logger.error("Erro ao abrir socket: " + e.getMessage());
            logger.error("O servidor " + arguments.getServerAddress() + " está disponivel?");
            logger.error("A sair do programa.");
            System.exit(0);
        }
        return res;

    }


}
