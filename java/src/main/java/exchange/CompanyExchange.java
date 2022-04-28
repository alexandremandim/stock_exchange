package exchange;

import org.zeromq.ZMQ;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe que contem as ordens de compra e venda em lista de uma empresa,
 * assim como um historico de todas as transações.
 * Metodos synhronized para poderem ser acedidos por varias threads
 */
public class CompanyExchange {

    private String companyName;                     // Nome da empresa
    private List<Order> sellOrders;                 // Ordens de venda à espera de serem satisfeitas
    private List<Order> buyOrders;                  // Ordens de compra à espera de serem satisfeitas
    private List<CompletedOrder> completedOrders;   // Histórico de transações completas
    ZMQ.Context context;
    ZMQ.Socket socket;
    public CompanyExchange(String companyName) {
        this.companyName = companyName;
        this.sellOrders = new ArrayList<>();
        this.buyOrders = new ArrayList<>();
        this.completedOrders = new ArrayList<>();
        this.context = ZMQ.context(1);
        this.socket = context.socket(ZMQ.PUB);
        socket.connect("tcp://*:11111");
    }

    public synchronized OrderWasSatisfied addSellOrder(Order sellOrder){
        // Obtem preco minimo de venda colocado na order
        int minPrice = sellOrder.getPrice();

        OrderWasSatisfied satsfied;

        /**
         * Ordens de compra saitsfeitas por esta ordem de venda e por isso
         * marcadas para remocao da lista de buyOrders
         */
        ArrayList<Order> buyOrdersToRemove = new ArrayList<>();

        /**
         * Chegou uma ordem de venda, vamos ver que ordens de
         * compra esta ordem de venda consegue satisfazer.
         */
        for(Order buyOrder:buyOrders){
            if(buyOrder.getPrice() > minPrice){

                /**
                 * O preco minimo de venda é mais baixo que o preço máximo
                 * de compra que alguem ofereceu, podemos fazer uma troca
                 */
                int qtdToExchange = Math.min(buyOrder.getQtd(), sellOrder.getQtd());
                buyOrder.decQtd(qtdToExchange);
                sellOrder.decQtd(qtdToExchange);

                completedOrders.add(new CompletedOrder(Instant.now(),
                                                        sellOrder.getOwner(),
                                                        buyOrder.getOwner(),
                                                        qtdToExchange,
                                                        buyOrder.getPrice()
                                                        ));

                if(buyOrder.getQtd() == 0){
                    /**
                     * Não há mais acçoes para comprar nesta order,
                     * podemos marcar para remoçao
                     */
                    buyOrdersToRemove.add(buyOrder);
                }

                if(sellOrder.getQtd() == 0){
                    /**
                     * Não há mais acções nesta order para vender,
                     * a order foi completamente satisfeita,
                     * podemos sair do ciclo e parar de procurar
                     */
                    break;
                }
            }
        }

        // Remove orders marcadas para remocao do ciclo anterior
        buyOrders.removeAll(buyOrdersToRemove);

        if(sellOrder.getQtd() == 0){
            socket.sendMore(companyName);
            socket.send("A order da empresa [" + companyName + "] de valor ["+ sellOrder.getPrice() +"] do user ["+sellOrder.getOwner() +"] foi concluida com sucesso!");
            return OrderWasSatisfied.YES;
        }else{
            /**
             * Se a order não tiver sido completamente satisfeita,
             * pomos na lista de sell orders e indicamos aos clientes
             * desta classe um valor que indica que a order nao foi
             * completamente satisfeita (mas foi adicionada)
             */

            socket.sendMore(companyName);
            socket.send("A order da empresa [" + companyName + "] de valor ["+ sellOrder.getPrice() +"] do user ["+sellOrder.getOwner() +"] não foi totalmente satisfeita mas foi adicionada à lista!");
            sellOrders.add(sellOrder);
            return OrderWasSatisfied.NO;
        }

    }

    public synchronized OrderWasSatisfied addBuyOrder(Order buyOrder){
        // Obtem preco maximo de compra colocado na order
        int maxPrice = buyOrder.getPrice();


        OrderWasSatisfied satsfied;

        /**
         * Ordens de venda saitsfeitas por esta ordem de compra e por isso
         * marcadas para remocao da lista de buyOrders
         */
        ArrayList<Order> sellOrdersToRemove = new ArrayList<>();

        /**
         * Chegou uma ordem de compra, vamos ver que ordens de
         * venda esta ordem de compra consegue satisfazer.
         */
        for(Order sellOrder:sellOrders){
            if(sellOrder.getPrice() < maxPrice){

                /**
                 * O preco minimo de venda é mais baixo que o preço máximo
                 * de compra que alguem ofereceu, podemos fazer uma troca
                 */
                int qtdToExchange = Math.min(buyOrder.getQtd(), sellOrder.getQtd());
                buyOrder.decQtd(qtdToExchange);
                sellOrder.decQtd(qtdToExchange);

                completedOrders.add(new CompletedOrder(Instant.now(),
                        sellOrder.getOwner(),
                        buyOrder.getOwner(),
                        qtdToExchange,
                        maxPrice
                ));

                if(sellOrder.getQtd() == 0){
                    /**
                     * Não há mais acçoes para comprar nesta order,
                     * podemos marcar para remoçao
                     */
                    System.out.println("TUDO removido");
                    sellOrdersToRemove.add(sellOrder);
                }

                if(buyOrder.getQtd() == 0){
                    /**
                     * Não há mais acções nesta order para vender,
                     * a order foi completamente satisfeita,
                     * podemos sair do ciclo e parar de procurar
                     */
                    break;
                }
            }
        }

        // Remove orders marcadas para remocao do ciclo anterior
        sellOrders.removeAll(sellOrdersToRemove);

        if(buyOrder.getQtd() == 0){
            socket.sendMore(companyName);
            socket.send("A order da empresa [" + companyName + "] de valor ["+ buyOrder.getPrice() +"] do user ["+buyOrder.getOwner() +"] foi concluida com sucesso!");
            return OrderWasSatisfied.YES;
        }else{
            /**
             * Se a order não tiver sido completamente satisfeita,
             * pomos na lista de buy orders e indicamos aos clientes
             * desta classe um valor que indica que a order nao foi
             * completamente satisfeita (mas foi adicionada)
             */
            socket.sendMore(companyName);
            socket.send("A order de compra na empresa [" + companyName + "] de valor ["+ buyOrder.getPrice() +"] do user ["+buyOrder.getOwner() +"] não foi totalmente satisfeita mas foi adicionada à lista!");

            buyOrders.add(buyOrder);
            return OrderWasSatisfied.NO;
        }

    }

    public synchronized String getCompanyName() {
        return companyName;
    }

    public synchronized List<Order> getSellOrders() {
        return sellOrders;
    }

    public synchronized List<Order> getBuyOrders() {
        return buyOrders;
    }

    public synchronized List<CompletedOrder> getCompletedOrders() {
        return completedOrders;
    }
}
