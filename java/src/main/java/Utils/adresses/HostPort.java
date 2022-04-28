package Utils.adresses;

/**
 * Classe qur visa apenas juntar a informacao de host e porta
 * Pode ser usada em alternativa ao InetSocketAddress...
 */
public class HostPort {

    private String host;
    private int port;

    public HostPort(){
        this.host="localhost";
        this.port=80;
    }

    public HostPort(String address){
        String split[] = address.split(":");
        this.host=split[0];
        this.port=Integer.valueOf(split[1]);
    }

    public String getHost() {
        return host;
    }

    public int getPort() {
        return port;
    }
}
