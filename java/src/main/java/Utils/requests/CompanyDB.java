package Utils.requests;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Classe que representa uma base de dados de empresas.
 * No fundo é apenas um Map que associa o nome de cada empresa ao
 * correspondente objecto do tipo Company que tem o
 * endereco da exchange onde as suas acçoes sao negociadas.
 *
 * Metodos synchronized, podem ser usados por varias threads.
 */
public class CompanyDB {

    /**
     * Base de dados por defeito, caso nao se consiga contactar o directorio.
     */
    public static CompanyDB getDefaultDB(){
        CompanyDB defaultDB = new CompanyDB();
        defaultDB.addCompany("edp", "localhost:7000","localhost:7001");
        defaultDB.addCompany("ctt", "localhost:7000","localhost:7001");
        return defaultDB;
    }

    /**
     * Mapeia o nome da empresa com o objecto java correspondente.
     * Este map tem informacao redundante, pois o nome da empresa
     * está tanto na chave como no objecto Company.
     * Em alternativa, poderia ter sido usado um HashSet.
     */
    private Map<String, Company> companyMap;

    public CompanyDB(){
        this.companyMap = new HashMap<>();
    }

    public CompanyDB(Map<String, Company> companyMap){
        this.companyMap = companyMap;
    }

    public synchronized boolean companyExists(String company){
        return companyMap.containsKey(company);
    }

    public synchronized void addCompany(String name, String clientaddr, String servidoraddr){
        companyMap.put(name,new Company(name, clientaddr, servidoraddr));
    }
    public synchronized void addCompany(Company c){
        companyMap.put(c.getName(),c);
    }

    public synchronized String getCompanyCAddress(String company){
        return companyMap.get(company).getClientaddr();
    }

    public synchronized String getCompanySAddress(String company){
        return companyMap.get(company).getServidoraddr();
    }

    public synchronized Set<String> getCompanyList(){
        return this.companyMap.keySet();
    }

}
