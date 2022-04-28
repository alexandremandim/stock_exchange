package server.args;

import joptsimple.OptionException;
import joptsimple.OptionParser;
import joptsimple.OptionSet;
import joptsimple.OptionSpec;

import java.net.InetSocketAddress;
import java.net.MalformedURLException;
import java.net.URL;

public class Parser {

    public static ParsedArguments parse(String[] args) throws OptionException, MalformedURLException {

        OptionParser parser = new OptionParser();

        /**
         * Especificação das opções que podem ser recebidas pelo programa.
         * Neste caso podem ser passadas as opções -da e -p
         * Exemplo de uso: cliente -da localhost:8080 -p 7777
         * da (derver address) = endereco e porta do directorio
         * p (porta) = porta para receber novas conexões de clientes
         */
        OptionSpec<Integer> p_opt =
                parser.accepts("p","Port where to listen")
                .withRequiredArg().ofType(Integer.class).defaultsTo(7777);

        OptionSpec<String> daddr_opt =
        parser.accepts("da","Address of directory server")
                .withRequiredArg().ofType(String.class).defaultsTo("localhost:8080");

        OptionSet options = parser.parse(args);

        URL baseURL = new URL("http://" + options.valueOf(daddr_opt));

        return new ParsedArguments(baseURL, options.valueOf(p_opt));
    }


    private Parser(){
    }

}
