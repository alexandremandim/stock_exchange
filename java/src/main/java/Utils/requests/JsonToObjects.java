package Utils.requests;

import com.google.gson.Gson;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Classse que apenas se destina a fornecer metodos de classe
 * para converter entre objectos e JSON e vice versa.
 */
public class JsonToObjects {

    /**
     * Converte uma string de texto JSON que contem uma lista de empresas:
     * "[{"name":"empresa1","info":"localhost:8080"},
     *  {"name":"empresa2","info":"localhost:8081"}]"
     *  num array java:
     *  [new Company("empresa1","localhost:8080"),
     *  new Company("empresa2","localhost:8081")]
     */
    public static Company[] getCompanyList(String companiesJson){
        Gson gson = new Gson();
        Company companies[] = gson.fromJson(companiesJson,Company[].class);
        return companies;
    }

    /**
     * Converte uma string de texto JSON que contem uma lista de empresas
     * para um map.
     * O map é preferivel às listas para permitir pesquisas mais eficientes.
     */
    public static Map<String,Company> getCompanyMap(String companiesJson){
        Gson gson = new Gson();

        Map<String,Company> res = new HashMap<>();

        Company companies[] = gson.fromJson(companiesJson,Company[].class);

        for(Company c: companies){
            res.put(c.getName(),new Company(c.getName(),c.getClientaddr(),c.getServidoraddr()));
        }

        return res;
    }

    /**
     * Esta funçao junta a funcao anterior com a funcao maakeRequest da classe Requests
     * para de uma so vez fazer um pedido ao directorio, obter a resposta JSON e converter
     * a resposta JSON num map pronto a servir para funcionar de base de dados em memoria.
     */
    public static Map<String, Company> getEmpresas(URL directoryBaseUrl) throws MalformedURLException {
        String baseUrlStr = directoryBaseUrl.toString();
        String requestUrl = baseUrlStr + "/empresas";

        Map<String, Company> res = null;

        String jsonStr = Requests.makeRequest("GET", requestUrl);
        res = JsonToObjects.getCompanyMap(jsonStr);

        return res;
    }

    /**
     * Como a classe so se destina a fornecer metodos de classe, o constructor privado
     * forca a que a tentativa de criacao de instancias nao deixe o programa compilar.
     */
    private JsonToObjects(){
    }


}
