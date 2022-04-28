package exchange;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Classe da exchange com a lista de todas as empresas.
 * Serve apenas de wrapper para o map companyExchanges e com isso
 * tornar o codigo das outras classes mais limpo.
 */
public class Exchange {

    private Map<String,CompanyExchange> companyExchanges;


    public Exchange(List<String> companies){
        companyExchanges = new HashMap<>();
        for (String company: companies){
            companyExchanges.put(company,new CompanyExchange(company));
        }
    }

    public CompanyExchange getExchange(String company){
        return companyExchanges.get(company);
    }

}
