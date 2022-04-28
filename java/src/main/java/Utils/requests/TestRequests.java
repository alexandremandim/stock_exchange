package Utils.requests;

import com.google.gson.Gson;

import java.net.MalformedURLException;

/**
 * Classe só para testar se os requests estavam a funcionar.
 * Nothing to see here, really :)
 */
public class TestRequests {
    public static void main(String[] args) {
        try {
            String empresasJson = Requests.get("http://localhost:8080/empresas");
            System.out.println(empresasJson);

            Gson gson = new Gson();
            Company companies[] = gson.fromJson(empresasJson,Company[].class);
            System.out.println("Empresas encontradas: " + companies.length);

            for(Company e: companies){
                System.out.println(e.toString());
            }

        } catch (MalformedURLException e) {
            System.out.println("URL invalido");
        }

    }
}
