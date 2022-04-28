package directory.Resource;

import directory.Representation.Empresa;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;
import java.util.ArrayList;
import java.util.HashSet;

@Path("/")
@Produces(MediaType.APPLICATION_JSON)
public class EmpresaResource {

    public HashSet<Empresa> empresas = new HashSet<>();
    //private final int id;
    private String name;
    private String clientaddr;
    private String servidoraddr;


    public EmpresaResource(String name) {
        this.name=name;

        /*this.clientaddr=clientaddr;
        this.servidoraddr=servidoraddr;
    */
    }


    @Path("/empresas")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public synchronized HashSet<Empresa> getEmpresas(){
        return empresas;
    }


    @POST
    @Path("/empresas/")
    public synchronized Response empresaPOST(@QueryParam("name") String name,
                                @QueryParam("clientaddr") String clientaddr,
                                @QueryParam("servidoraddr") String servidoraddr){


        Empresa obj = new Empresa(name, clientaddr, servidoraddr);
        if(!empresas.add(obj)){
            empresas.remove(obj);
            empresas.add(obj);

        }else{
            empresas.add(obj);
        }


        return Response.ok().build();

    }

    @DELETE
    @Path("/empresas/")
    public synchronized Response empresaDELETE(@QueryParam("name") String name){
        for (Empresa e: empresas) {
            if(e.getName().equals(name)){
                empresas.remove(e);
            }
        }
        return Response.ok().build();

    }



}
