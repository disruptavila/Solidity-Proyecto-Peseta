/*
 * 	Nombre: 5-modificadores-Peseta-ICO.sol
 *	Version:	v0.1
 *	Autor:	Jorge Martin
 *	Fecha:	noviembre 2017
 *	Descripcion:		5-modificadores-Peseta-ICO.sol 
 *                  Empezaremos desde cero y proporcionalmente llegaremos a terminar, en su conjunto,
 *                  la creación de una ICO llamada peseta, empezamos con código para saber de que va esto...
 *
 */
 
/* Declaracion pragma */

pragma solidity ^0.4.0;

contract Pesetas {
    
    
    address propietario;
    mapping ( address => uint ) public balances;
    
    //declaramos el evento para tener chequeado, escuchar a ver si se transfiere el dinero
    event TransferidoDinero (address from, address to, uint amount);
    
    //modificadores
    modifier soloPropietario () {
        if (msg.sender == propietario){
            _;
        }
        
    }
    
    //lanzamos el constructor
    // se tiene que llamar igual que el contrato
    function Pesetas () {
        propietario = msg.sender;
        
        //creamos el dinero
        balances [ propietario] = 1000000;
        
    }
    
    function getBalance () constant returns (uint) {
            return this.balance;
    }
    
    
    function transfierePesetas ( address destino, uint importe)  {
        
        
        //al poner el require, podemos quitar todo el if /return
        if( balances [msg.sender] < importe){
            return;  //control y te vas, no hace falta else
        } 
        
        TransferidoDinero (msg.sender, destino, importe);
        
        //primero se lo quito a quien tiene.
        //cuidado porque puede pasar un DAO problem
        balances[msg.sender] = balances [msg.sender] + importe;
        
        //despues se lo agrego
        //despues de consultar valor, lo guardo en el mapa.
        balances[destino] = balances [destino] - importe;
        
        
    }
    
    //para comprar Pesetas
    //logica: 
        // al balance de propietario, 
        // le sumamos el valor de msg.value 
        // le dividimos entre / 1 ether para que no de tantos ceros
    function  comprarPesetas  ()  payable  {
        
        balances [msg.sender] = balances [msg.sender] + msg.value / 1 ether ;
        
        
    }
    
    
    
    
    
    //funcion sacar dinero
    function sacarDinero() soloPropietario () {
        
        //comprobar que solo el propietario puede usarla
        //if (propietario != msg.sender){
        //    return;
        //}
        
        //despues de declarar el modifier, podemos quitar el if de checquear propietario
        
        //el 0x0 es la direccion wallet de la persona a la que mandar el dinero antes de suicidar
        //cambiamos 0x0 por propietario, dsepues de comprobar que sender y propietario son los mismos
        //cantidad de ethes que tiene el contrato
        propietario.transfer(this.balance);
        
    }
    
    //funcion suicidame
    function matame() soloPropietario() {
        
        //comprobar que solo el propietario puede usarla
        //al llamar a soloPropietario(), 
        //podemos quitar el if de propietario
        //if (propietario != msg.sender){
        //   return;
        //}
        
            //el 0x0 es la direccion wallet de la persona a la que mandar el dinero antes de suicidar
            //cambiamos 0x0 por propietario, dsepues de comprobar que sender y propietario son los mismos
        suicide(propietario);
        
    }
    
    
    //funcion aumentar cantidad total de dinero
    function aumentarCantidad( uint aumentar) {
        
        //comprobar que solo el propietario puede usarla
        if (propietario != msg.sender){
            return;
        }
        
            
         balances [propietario] =+ aumentar;
        
    }
    
}
