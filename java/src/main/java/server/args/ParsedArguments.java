package server.args;

import java.net.URL;


/**
 * Esta classe tem o mesmo objectivo que a classe client.args.ParsedArguments
 * mas para o servidor.
 */
public class ParsedArguments {

    private URL directoryBaseUrl;       // Url de base de directorio. Por defeito http://localhost:8080
                                        // A este URL será adicionado o path dos recursos
                                        // para interacção com a API

    private int port;                   // Porta onde ouvir pedidos dos clientes

    /**
     * Nao permitir que sejam criadas instancias da classe sem enderecos
     */
    private ParsedArguments(){}

    public ParsedArguments(URL directoryBaseUrl, int port) {
        this.directoryBaseUrl = directoryBaseUrl;
        this.port = port;
    }

    public int getPort() {
        return port;
    }

    public URL getDirectoryBaseUrl() {
        return directoryBaseUrl;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("ParsedArguments{");
        sb.append("directoryBaseUrl=").append(directoryBaseUrl);
        sb.append(", port=").append(port);
        sb.append('}');
        return sb.toString();
    }
}
