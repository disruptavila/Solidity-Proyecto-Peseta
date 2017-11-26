/*	Comentarios sobre lo que el contracto realiza */
/*
 * 	Nombre: 2-Structs-Peseta-ICO.sol
 *	Version:	v0.1
 *	Autor:	Jorge Martin
 *	Fecha:	noviembre 2017
 *	Descripcion:		2-Structs-Peseta-ICO.sol 
 *                  Empezaremos desde cero y proporcionalmente llegaremos a terminar, en su conjunto,
 *                  la creación de una ICO llamada peseta, empezamos con código para saber de que va esto...
 *
 */
 
/* Declaracion pragma */

pragma solidity ^0.4.0;

contract Pesetas {
    
    //2-declaramos la variable propietario
    address propietario;
    
    //2-usamos el mapping para preguntar balances
        //
    mapping ( address => int ) balances;
     
    //lanzamos el constructor
    // se tiene que llamar igual que el contrato
    function Pesetas () {
        
        
    }
    
    //funcion suicidame
    function matame() {
            //el 0x0 es la direccion wallet de la persona a la que mandar el dinero antes de suicidar
        suicide(0x0);
        
    }
    
    
}
