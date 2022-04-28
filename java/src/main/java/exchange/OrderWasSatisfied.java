package exchange;


/**
 * Emnumeração simples que indica se uma ordem de compra/venda
 * foi satisfeita completamente ao dar entrada no sistema.
 * (ver retorno funcoes addSellOrder e addBuyOrder)
 *
 * Esta enumeração tem como objectivo tornar o código mais legivel,
 * pois a alternativa seria colocar as funções addSellOrder e addBuyOrder
 * a retornar um booleano para este efeito, mas a legibilidade seria pior.
 *
 * E.g:
 *
 * if(addSellOrder(...)){...}
 * VS
 * if(addSellOrder(...) == OrderWasSatisfied.YES){...}
 *
 */
enum OrderWasSatisfied {
    YES,NO;
}
