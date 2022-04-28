package exchange;

import java.time.Instant;

/**
 * Classe que guarda a informação das ordens de compra/venda
 * enquanto uma transação não é efectuada.
 * Depois de se efectuar uma transação de acções é gerada
 * uma instancia da classe CompletedOrder.
 */

public class Order {

    private OrderType orderType;    // Indica se é ordem de compra ou venda
    private String owner;           // Username de quem colocou a order
    private int price;              // Preco minimo de venda ou maximo de compra
    private int qtd;                // Numero de accoes
    private Instant timestamp;      // Tempo em que a order foi colocada

    public Order(){}

    public Order(OrderType orderType,
                 String owner,
                 int price,
                 int qtd,
                 Instant timestamp) {
        this.orderType = orderType;
        this.owner = owner;
        this.price = price;
        this.qtd = qtd;
        this.timestamp = timestamp;
    }

    public OrderType getOrderType() {
        return orderType;
    }

    public String getOwner() {
        return owner;
    }

    public int getPrice() {
        return price;
    }

    public int getQtd() {
        return qtd;
    }

    public void decQtd(int val){
        this.qtd -= val;
    }

    public Instant getTimestamp() {
        return timestamp;
    }


}
