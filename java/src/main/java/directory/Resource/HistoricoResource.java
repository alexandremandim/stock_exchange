package directory.Resource;

import com.fasterxml.jackson.core.JsonProcessingException;
import directory.Representation.Empresa;
import directory.Representation.Historico;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@Path("/")
@Produces(MediaType.APPLICATION_JSON)
public class HistoricoResource {

    public Map<String, ArrayList<Historico>> historico = new HashMap<>();

    //private final int id;

    private String name;
    private String info;

    public HistoricoResource(String name, String info) {
        this.name=name;
        this.info=info;
    }


    @Path("/historicos/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public synchronized Map<String, ArrayList<Historico>> sendHistorico() throws JsonProcessingException {
        //ObjectMapper mapper = new ObjectMapper();
        //String s = mapper.writeValueAsString(historico);
        return historico;
    }

    @Path("/historico/{empresa}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public synchronized ArrayList<Historico> getEmpresaHistorico(@PathParam("empresa") String empresa) throws JsonProcessingException {
        /**
         * Isto aqui dá a lista de historico de uma empresa;
         * Não está limitado a apenas 10;
         * */

        //TODO: ver como se faz return quando nao tiver nada
        if(historico.containsKey(empresa)){
            return historico.get(empresa);
        } else {
            return null;
        }
    }


    @POST
    @Path("/historico/")
    public synchronized Response historicoPOST(@QueryParam("empresa") String empresa,
                                @QueryParam("oldowner") String oldOwner,
                                @QueryParam("newowner") String newOwner,
                                @QueryParam("qtd") String qtd,
                                @QueryParam("price") String price
                                ){
        if(historico.containsKey(empresa)){
            historico.get(empresa).add(new Historico(oldOwner, newOwner, qtd, price, empresa));
        } else{
            historico.put(empresa,new ArrayList<>());
            historico.get(empresa).add(new Historico(oldOwner, newOwner, qtd, price,empresa));
        }

        return Response.ok().build();

    }


}
