package directory.Representation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public class Historico {
    private String oldOwner;
    private String newOwner;
    private String qtd;
    private String price;
    private String empresa;

    public Historico() {
        // Jackson deserialization
    }


    @JsonCreator
    public Historico(@JsonProperty("oldowner") String oldOwner,
                     @JsonProperty("newowner") String newOwner,
                     @JsonProperty("qtd") String qtd,
                     @JsonProperty("price") String price,
                     @JsonProperty("empresa") String empresa) {

        this.oldOwner=oldOwner;
        this.newOwner=newOwner;
        this.qtd=qtd;
        this.price=price;
        this.empresa=empresa;
    }

    @JsonProperty
    public String getOldOwner() {
        return oldOwner;
    }
    @JsonProperty
    public String getNewOwner() {
        return newOwner;
    }
    @JsonProperty
    public String getQtd() {
        return qtd;
    }
    @JsonProperty
    public String getPrice() {
        return price;
    }
    @JsonProperty
    public String getEmpresa() {
        return empresa;
    }


}
