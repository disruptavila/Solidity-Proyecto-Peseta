/*
 * 	Nombre: 3-transferir-Peseta-ICO.sol
 *	Version:	v0.1
 *	Autor:	Jorge Martin
 *	Fecha:	noviembre 2017
 *	Descripcion:		3-transferir-Peseta-ICO.sol 
 *                  Empezaremos desde cero y proporcionalmente llegaremos a terminar, en su conjunto,
 *                  la creación de una ICO llamada peseta, empezamos con código para saber de que va esto...
 *
 */
 
/* Declaracion pragma */

pragma solidity ^0.4.0;

contract Pesetas {
    
    
    address propietario;
    mapping ( address => uint ) balances;
    
    //lanzamos el constructor
    // se tiene que llamar igual que el contrato
    function Pesetas () {
        
        
    }
    
    function transfierePesetas ( address origen, address destino, uint importe) {
        
        if( balances [origen] < importe){
            return;  //control y te vas, no hace falta else
        } 
        
        
        //primero se lo quito a quien tiene.
        //cuidado porque puede pasar un DAO problem
        balances[destino] = balances [destino] + importe;
        
        //despues se lo agrego
        //despues de consultar valor, lo guardo en el mapa.
        balances[origen] = balances [origen] - importe;
        
        
    }
    
    //funcion suicidame
    function matame() {
            //el 0x0 es la direccion wallet de la persona a la que mandar el dinero antes de suicidar
        suicide(0x0);
        
    }
    
    
}
