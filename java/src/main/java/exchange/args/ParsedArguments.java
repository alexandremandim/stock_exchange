package exchange.args;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * Esta classe tem o mesmo objectivo que a classe client.args.ParsedArguments
 * mas para o servidor.
 */
public class ParsedArguments {

    private URL directoryBaseUrl;       // Endereço do directorio
    private int serverPort;             // Porta que ira ficar à escuta dos pedidos do servidor
    private int publishPort;            // Porta em que a exchange irá colocar as publicações para os clientes
    private List<String> companies;     // Empresas negociadas na exchange

    /**
     * Nao permitir que sejam criadas instancias da classe sem argumentos
     */
    private ParsedArguments(){}

    public ParsedArguments(URL directoryBaseUrl,
                           int serverPort,
                           int publishPort,
                           List<String> companies) {
        this.directoryBaseUrl = directoryBaseUrl;
        this.serverPort = serverPort;
        this.publishPort = publishPort;
        this.companies = new ArrayList<>(companies);
    }

    public int getServerPort() {
        return serverPort;
    }

    public int getPublishPort() {
        return publishPort;
    }

    public URL getDirectoryBaseUrl() {
        return directoryBaseUrl;
    }

    public List<String> getCompanies() {
        return companies;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("ParsedArguments{");
        sb.append("directoryBaseUrl=").append(directoryBaseUrl);
        sb.append(", serverPort=").append(serverPort);
        sb.append(", publishPort=").append(publishPort);
        sb.append(", companies=").append(companies);
        sb.append('}');
        return sb.toString();
    }
}
