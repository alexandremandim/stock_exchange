package directory.Application;

import directory.Configuration.DirectoryConfiguration;
import directory.Resource.EmpresaResource;
import directory.Resource.HistoricoResource;
import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

public class DirectoryApplication extends io.dropwizard.Application<DirectoryConfiguration> {
    public static void main(String[] args) throws Exception {
        System.out.println("Directory");
        new DirectoryApplication().run(args);
    }


    public void initialize(Bootstrap<DirectoryConfiguration> bootstrap) {
        // nothing to do yet
        /*TODO: used to configure aspects of the application required before the application
        is run, like bundles, configuration source providers, etc*/
    }

    public void run(DirectoryConfiguration directoryConfiguration, Environment environment) throws Exception {
        // nothing to do yet
        //Aqui corre cenas
        //TODO: registar aqui tb o historico
        environment.jersey().register(new EmpresaResource(directoryConfiguration.getDefaultName()));
        environment.jersey().register(new HistoricoResource(directoryConfiguration.getTemplate(), directoryConfiguration.getDefaultName()));
    }

    public String getName(){
        return "Diretorio";
    }
}
