package exchange;

import java.time.Instant;

/**
 * Classe que representa uma transação completa.
 * Usada para se guardar histórico de transações
 */

public class CompletedOrder {

    private Instant completedAt;
    private String oldOwner;
    private String newOwner;
    private int qtd;
    private int price;

    public CompletedOrder(Instant completedAt, String oldOwner, String newOwner, int qtd, int price) {
        this.completedAt = completedAt;
        this.oldOwner = oldOwner;
        this.newOwner = newOwner;
        this.qtd = qtd;
        this.price = price;
    }

    public Instant getCompletedAt() {
        return completedAt;
    }

    public String getOldOwner() {
        return oldOwner;
    }

    public String getNewOwner() {
        return newOwner;
    }

    public int getQtd() {
        return qtd;
    }

    public int getPrice() {
        return price;
    }



}
