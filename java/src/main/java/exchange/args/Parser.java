package exchange.args;

import joptsimple.OptionException;
import joptsimple.OptionParser;
import joptsimple.OptionSet;
import joptsimple.OptionSpec;

import java.lang.reflect.Array;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;

public class Parser {

    public static ParsedArguments parse(String[] args) throws OptionException, MalformedURLException {


        OptionParser parser = new OptionParser();

        /**
         * Especificação das opções que podem ser recebidas pelo programa.
         * Neste caso podem ser passadas as opções -da e -p
         * Exemplo de uso: cliente -da localhost:8080 -ps 7777 -pc 7778 -c empresa1 -c empresa2
         * da (derver address)  = endereco e porta do directorio
         * ps (port server)     = porta onde ouvir pedidos do servidor
         * pc (port client)     = porta onde colocar publicaçoes para os clientes
         * c (company)          = especifica empresa a ser negociada nesta exchange.
         *                          Pode ser especificado mais que uma vez.
         */
        OptionSpec<Integer> pc_opt =
                parser.accepts("pc","Port where to publish messsages to the client")
                .withRequiredArg().ofType(Integer.class).defaultsTo(7000);

        OptionSpec<Integer> ps_opt =
                parser.accepts("ps","Port where to list requests from server")
                        .withRequiredArg().ofType(Integer.class).defaultsTo(7001);

        OptionSpec<String> daddr_opt =
        parser.accepts("da","Address of directory server")
                .withRequiredArg().ofType(String.class).defaultsTo("localhost:8080");

        OptionSpec<String> c_opt =
                parser.accepts("c","Specifies a company served by this exhange")
                        .withRequiredArg().ofType(String.class).defaultsTo("ctt","edp");

        OptionSet options = parser.parse(args);

        ArrayList<String> companies = new ArrayList<>();

        for(String company:options.valuesOf(c_opt)){
            companies.add(company);
        }

        URL baseURL = new URL("http://" + options.valueOf(daddr_opt));

        return new ParsedArguments(baseURL,
                                    options.valueOf(ps_opt),
                                    options.valueOf(pc_opt),
                                    companies);
    }


    private Parser(){
    }

}
