package Utils.requests;

import client.Main;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

public class Requests {

    public final static Logger logger = LoggerFactory.getLogger(Requests.class);

    private Requests(){}

    /**
     * Estas 3 funções a seguir apenas têm como objectivo facilitar
     * as chamadas à função que realmente faz os pedidos, a makeRequest()
     *
     * Estas funções foram fortemente inspiradas pelas funções com o
     * mesmo objectivo no Python.
     * Em Python um request pode ser feito com requests.get(url)
     * Com este código obtem-se algo parecido: Requests.get(url)
     */
    public static String get(String url) throws MalformedURLException {
        return makeRequest("GET", url);
    }

    public static String put(String url) throws MalformedURLException {
        return makeRequest("PUT", url);
    }

    public static String post(String url) throws MalformedURLException {
        return makeRequest("POST", url);
    }

    /**
     * Faz pedido HTTP a um endereço e devolve a String com o resultado
     * obtido como resposta. No caso da interação com API's a string será JSON.
     *
     * O method deverá ser uma string GET, POST, PUT etc...
     */
    public static String makeRequest(String method, String url) throws MalformedURLException {

        URL urlRequest = new URL(url);
        String jsonStr = null;
        HttpURLConnection connection = null;
        try {
            connection = (HttpURLConnection) urlRequest.openConnection();

            try {
                connection.setRequestMethod("GET");
                connection.setRequestProperty("Connection", "Keep-Alive");
                connection.setDoOutput(true);

                int status = connection.getResponseCode();
                if (status == HttpURLConnection.HTTP_OK) {

                    InputStream inputStream = connection.getInputStream();

                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

                    int bytesRead;
                    byte[] buffer = new byte[16 * 1024 * 1024];
                    // Le bytes da resposta para um array e bytes
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    // Converte array de bytes em string. Como se trata de uma API REST,
                    // a string será JSON. Aqui assume-se que a string está com encoding
                    // UTF-8.
                    jsonStr = outputStream.toString("UTF-8");
                    outputStream.close();
                    inputStream.close();
                } else {
                    logger.warn("Reply code NOT OK: "+status);
                }

            } catch (ProtocolException e) {
                logger.error(e.getMessage());
            } catch (UnsupportedEncodingException e) {
                logger.error(e.getMessage());
            } catch (IOException e) {
                logger.error(e.getMessage());
            } finally {
                // Quer tenha ou nao havido excepcoes, tentar fechar a conexão
                connection.disconnect();
            }
        } catch (IOException e) {
            // Falha ao conectar
            logger.error("Erro ao conectar:" + e.getMessage());
        }


        return jsonStr;
    }

}
