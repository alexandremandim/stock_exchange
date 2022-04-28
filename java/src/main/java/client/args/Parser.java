package client.args;

import joptsimple.OptionException;
import joptsimple.OptionParser;
import joptsimple.OptionSet;
import joptsimple.OptionSpec;

import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Faz parsing dos argumentos passados pela linha de comandos ao programa.
 */

public class Parser {

    /**
     * Função que recebe e trata os argumentos passados ao programa
     * pela linha de comandos
     */
    public static ParsedArguments parse(String[] args) throws OptionException, MalformedURLException {

        OptionParser parser = new OptionParser();


        /**
         * Especificação das opções que podem ser recebidas pelo programa.
         * Neste caso podem ser passadas as opções -sa e -da
         * Exemplo de uso: cliente -sa localhost:7777 -da localhost:8080
         * sa (server address) = endereco e porta do servidor
         * da (directory address) = endereco e porta do directorio
         */
        OptionSpec<String> saddr_opt =
                parser.accepts("sa","Address of main server")
                .withRequiredArg().ofType(String.class).defaultsTo("localhost:7777");

        OptionSpec<String> daddr_opt =
        parser.accepts("da","Address of directory server")
                .withRequiredArg().ofType(String.class).defaultsTo("localhost:8080");


        OptionSet options = parser.parse(args);

        /**
         * Converte opção -sa de string para InetSocketAddress
         * Como este endereço vai ser usado para a criaçao de um socket
         * apenas interessa o endereco e a porta dai ser usado InetSocketAddress
         */

        InetSocketAddress server = stringToInetSocketAddr(options.valueOf(saddr_opt));


        /**
         * Converte opção -da de string para URL
         * Este endereço será usado para pedidos HTTP ao directorio, para os quais
         * a classe URL é mais adequada.
         */
        URL baseURL = new URL("http://" + options.valueOf(daddr_opt));

        // Junta os dois argumentos numa instancia ParsedArguments.
        return new ParsedArguments(server,baseURL);
        }

    /**
     * Um InetSocketAddress pode ser visto como um tuplo com um endereço e uma porta.
     * Esta função pega em strings do tipo "locahost:8080" e converte para um endereço
     * InetSocketAddress.

     */
    private static InetSocketAddress stringToInetSocketAddr(String addr){
        String split[] = addr.split(":");
        return new InetSocketAddress(split[0], Integer.valueOf(split[1]));
    }

    /**
     * Esta classe apenas tem como objectivo disponibilizar funcionalidades
     * atraves de metodos de classe. A criação de instancias nao faz sentido
     * e é um erro. Para garantir que nao sao criadas instancias, usa-se constructor privado.
     */
    private Parser(){
    }

}
