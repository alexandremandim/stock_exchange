package directory.Representation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import org.hibernate.validator.constraints.Length;

import java.util.concurrent.atomic.AtomicInteger;

public class Empresa {
    //private static final AtomicInteger id = new AtomicInteger(0);
    private String name;
    private String clientaddr;
    private String servidoraddr;

    public Empresa() {
        // Jackson deserialization
    }
    @JsonCreator
    public Empresa(@JsonProperty("name") String name,
                   @JsonProperty("clientaddr") String clientaddr,
                   @JsonProperty("servidoraddr") String servidoraddr
    ) {
        this.name = name;

        this.clientaddr = clientaddr;
        this.servidoraddr = servidoraddr;
    }

    @JsonProperty
    public String getName() {
        return name;
    }

    @JsonProperty
    public String getClientaddr() {
        return clientaddr;
    }

    @JsonProperty
    public String getServidoraddr() {
        return servidoraddr;
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
        Empresa empresa = (Empresa) o;
        return this.name.compareTo(empresa.getName())==0;
    }

    @Override
    public int hashCode() {
        return this.name.hashCode();
    }
}
