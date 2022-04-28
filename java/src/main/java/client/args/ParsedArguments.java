package client.args;

import java.net.InetSocketAddress;
import java.net.URL;

/**
 * Esta classe disponibiliza ao programa uma forma facil de trabalhar
 * com os argumentos que recebeu pela linha de comandos, uma vez que
 * estes já foram tratados e colocados com os tipos adequados ao uso pelo
 * programa.
 */
public class ParsedArguments {

    private InetSocketAddress serverAddress;
    private URL directoryBaseUrl;

    /**
     * Nao permitir que sejam criadas instancias da classe sem enderecos
     */
    private ParsedArguments(){}

    public ParsedArguments(InetSocketAddress serverAddress, URL directoryBaseUrl) {
        this.serverAddress = serverAddress;
        this.directoryBaseUrl = directoryBaseUrl;
    }

    public InetSocketAddress getServerAddress() {
        return serverAddress;
    }

    public URL getDirectoryBaseUrl() {
        return directoryBaseUrl;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("ParsedArguments{");
        sb.append("serverAddress=").append(serverAddress);
        sb.append(", directoryAddress=").append(directoryBaseUrl);
        sb.append('}');
        return sb.toString();
    }
}
