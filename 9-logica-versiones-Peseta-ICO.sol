/*
 * 	Nombre: 9-logica-versiones-Peseta-ICO.sol
 *	Version:	v0.1
 *	Autor:	Jorge Martin
 *	Fecha:	noviembre 2017
 *	Descripcion:		9-logica-versiones-Peseta-ICO.sol
 *                  Empezaremos desde cero y proporcionalmente llegaremos a terminar, en su conjunto,
 *                  la creación de una ICO llamada peseta, empezamos con código para saber de que va esto...
 *
 */
 
/* Declaracion pragma */

pragma solidity ^0.4.0;

contract logicaPeseta {
    
    function logicaPeseta() {
        
    }
    
    function transfierePesetas ( address origen, address destino, uint importe)  {
        
        Pesetas almacenamiento = Pesetas (msg.sender);
        require (almacenamiento.balances (origen) >= importe);
        
        almacenamiento.restadeBalace(origen, importe);
        almacenamiento.anayadeBalace(destino, importe);
        
        //TransferidoDinero (msg.sender, destino, importe);
        //balances[msg.sender] = balances [msg.sender] + importe;
        //balances[destino] = balances [destino] - importe;
        
        
    }
    
}



contract Pesetas {
    
    address contratoDeLaLogica;
    address propietario;
    
    //Lista nominados, la declaramos en la parte superior, la desarrollamos mas abajo
    address [] listaNominados;
    
    //la lista de los votos la guardamos en un mapping, el total de votos
    mapping ( address => uint ) votosPorNominados;
    
    //guarda quien ha votado, 
    mapping (address => uint) personaHaVotado;
    
    uint idVotacion = 0;
    uint fechaFinalizacionVotacion = 0;
    
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
    
    function anayadeBalace (address cliente, uint cantidad){
        //penalizo para quien lo use
        
        assert (msg.sender == contratoDeLaLogica);
        balances[cliente] += cantidad;
        
    }
    
    function restadeBalace (address cliente, uint cantidad){
        
        assert (msg.sender == contratoDeLaLogica);
        balances[cliente] -= cantidad;
        
    }
    
    function setLogica (address nuevoContratoLogica) soloPropietario() {
        contratoDeLaLogica = nuevoContratoLogica;
    }
    
    function transfierePesetas ( address destino, uint importe) soloPropietario() {
        //poner require (activo); en todas las funciones para usarlo en todos.
        require (activo);
        logicaPeseta logica = logicaPeseta (contratoDeLaLogica);
        logica.transfierePesetas(msg.sender, destino, importe);
        TransferidoDinero (msg.sender, destino, importe);
        //quitamos todo lo que ya hayamos pasado a la logica.
    }
    
    //para comprar Pesetas
    //logica: 
        // al balance de propietario, 
        // le sumamos el valor de msg.value 
        // le dividimos entre / 1 ether para que no de tantos ceros
    function  comprarPesetas  ()  payable  {
        
        balances [msg.sender] = balances [msg.sender] + msg.value / 1 ether ;
        
        
    }
    
    ///////// puerta trasera

    bool public activo = true;
    
    function desactivaContrato () soloPropietario () {
        activo = false;
    }
    
    //en todos los metodos hay que poner
    // require (activo);
    
    
    //////
    
    
    
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
    
    
    //COMIENZA LA VOTACION
    function comienzaVotacion () soloPropietario {
        idVotacion++;
        //fechaFinalizacionVotacion = now + 5 days;
        //para asegurar que no compren las votaciones, cambiamos now por el numero de bloque
        fechaFinalizacionVotacion = block.number + 5000;
    }
    
    //Anñadimos nominados a la lista para ser votados
    function addNominados ( address nominado ) soloPropietario {
        uint newID = listaNominados.length++;
        listaNominados[newID] = nominado;
        
    }
    
    function finalizaVotacion () soloPropietario () {
        address ganador;
        uint maximoVotos;
        
        for ( uint i=0; i < listaNominados.length; i++ ) {
            address nominado = listaNominados[i];
            uint votosNominados = votosPorNominados[nominado];
            
            if (votosNominados > maximoVotos) {
                ganador = nominado;
                maximoVotos = votosNominados;
            }
            //igualamos la lista de votos por nominado a cero para que en la 
            //proxima votacion no empieze con mas votos
            votosPorNominados[nominado] = 0;
        }
        
        delete listaNominados;
        balances[ganador] += 10000000;
        
    }
    
    function votaNominado ( address votado) {
        //tambien cambiamos el now por block.number
        require ( block.number < fechaFinalizacionVotacion);
        require ( balances[msg.sender] > 500);
        require ( personaHaVotado[msg.sender] < idVotacion );
        
        votosPorNominados[votado] = votosPorNominados[votado] +1;
        personaHaVotado[msg.sender] = idVotacion;
        
    }
     
}
