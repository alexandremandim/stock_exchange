package pubsub;

import org.zeromq.ZMQ;

public class Broker {
    public static void main(String[] args){
        ZMQ.Context context = ZMQ.context(1);

        ZMQ.Socket xsub = context.socket(ZMQ.XSUB);
        ZMQ.Socket xpub = context.socket(ZMQ.XPUB);

        System.out.println(xsub.bind("tcp://*:11111"));
//        System.out.println(xsub.bind("tcp://*:11111" + args[0]));
        System.out.println(xpub.bind("tcp://*:22222"));
//        System.out.println(xpub.bind("tcp://*:" + args[1]));

        new Proxy(context,xsub,xpub).poll();
    }
}
