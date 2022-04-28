package Utils.requests;


/**
 * Classe que representa uma empresa.
 * O nome das variáveis desta classe tem que ser o mesmo que os campos
 * devolvidos pela API do directorio. Desse modo, pode ser usada pela biblioteca GSON
 * para conversao de JSON em objectos desta classe e vice versa.
 */
public class Company {
    private String name;            // Nome da empresa

    private String clientaddr;      // Endereço e porta onde o cliente
                                    // se deve ligar para subscrever esta empresa.
                                    // É por isso um endereço da exchange.
                                    // e.g "localhost:7001"
    private String servidoraddr;    // Endereço e porta onde o servidor
                                    // se deve ligar para enviar pedidos de compra/venda acções.
                                    // É por isso um endereço da exchange.
                                    // e.g "localhost:7011"

    Company() {
        // no-args constructor
    }

    public Company(String name, String clientaddr, String servidoraddr) {
        this.name = name;
        this.clientaddr = clientaddr;
        this.servidoraddr = servidoraddr;
    }

    public String getName() {
        return name;
    }

    public String getClientaddr() {
        return clientaddr;
    }

    public String getServidoraddr() {
        return servidoraddr;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("Company{");
        sb.append("name='").append(name).append('\'');
        sb.append(", clientaddr='").append(clientaddr).append('\'');
        sb.append(", servidoraddr='").append(servidoraddr).append('\'');
        sb.append('}');
        return sb.toString();
    }

    /**
     * Equals e hashcode determinados apenas pelo nome.
     * Isto implica que o nome passa a funcionar como um id
     * para estruturas de dados como HashMap's, Set's etc...
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Company company = (Company) o;
        return this.name.compareTo(company.getName())==0;
    }

    @Override
    public int hashCode() {
        return this.name.hashCode();
    }
}
