package exchange;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import protobuf.order.Order;

import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import java.time.Instant;

public class ServerHandler extends Thread {

    private Socket socket;
    private Exchange exch;

    public final static Logger logger = LoggerFactory.getLogger(ServerHandler.class);

    public ServerHandler(Socket socket, Exchange exch) {
        this.socket = socket;
        this.exch = exch;
    }

    @Override
    public void run() {

        try {
            while (socket.isConnected()) {
                InputStream in = socket.getInputStream();


                Order.OrderRequestData protoOrder = Order.OrderRequestData.parseDelimitedFrom(in);

                exchange.Order exchOrder = protoOrderToExchangeOrder(protoOrder);

                CompanyExchange companyExchange = exch.getExchange(protoOrder.getCompany());

                OrderWasSatisfied wasSatisfied = null;






                switch (protoOrder.getOrderType()) {
                    case BUY:
                        logger.info("Ordem de compra recebida");
                        wasSatisfied = companyExchange.addBuyOrder(exchOrder);
                        break;
                    case SELL:
                        logger.info("Ordem de venda recebida");
                        wasSatisfied = companyExchange.addSellOrder(exchOrder);
                        break;
                    case UNRECOGNIZED:
                        logger.info("Ordem nao reconhecida");
                        break;
                    default:
                        logger.warn("Caso default ao processar order");
                }

                if (wasSatisfied == OrderWasSatisfied.YES) {
                    logger.info("A ordem conseguiu ser satisfeita imediatamente.");
                } else {
                    logger.info("A ordem não conseguiu ser satisfeita imediatamente, mas foi registada");
                }

            }
        } catch (IOException e) {
            logger.error(e.getMessage());
        } finally {
            // Quer tenha havido ou nao excepcoes, tentar fechar o scoket.
            try {
                socket.close();
            } catch (IOException e) {
                logger.error("Erro a fechar socket: " + e.getMessage());
            }
        }

    }


    public exchange.Order protoOrderToExchangeOrder(Order.OrderRequestData order) {
        OrderType type = null;

        switch (order.getOrderType()) {
            case BUY:
                type = OrderType.BUY;
                break;
            case SELL:
                type = OrderType.SELL;
                break;
            default:
                logger.warn("Caso default a converter orders.");
        }

        return new exchange.Order(type,
                order.getUsername(),
                order.getPrice(),
                order.getQtd(),
                Instant.now());
    }
}
