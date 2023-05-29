// SPDX-License-Identifier: UNLICENSED"
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;


// ----------------------------------
// CANDIDATO  /  EDAD  /  ID
//-----------------------------------
//  EDGAR    /   32    /  12345X
//  VALE     /   30    /  X54321
//  KAY      /   49    /  56789W
//  LEO      /   99    /  96474F


contract votacion{

    //Direccion del propietario del contrato
    address public owner;

    //Constructor
    constructor() public {
        owner = msg.sender;
    }

    //Relacion entre el nombre del candidato y el hash de sus datos personales
    mapping (string=> bytes32) ID_Candidato;

    //Relacion entre el nombre del candidato y nuemro de votos
    mapping (string=>uint) votos_Candidato;

    //Lista para almacenar los nombres de los candidatos
    string[] candidatos;

    //Lista de los hashes de la identidad de los votantes
    bytes32[] votantes;

    //Cualquier persona puede usar esta funcion para presentarse a las elecciones
    function Representar(string memory _nombrePersona, uint _edadPersona,string memory _idPersona) public{

        //Calcular es hash de los datos del candidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _idPersona));

        //Almacenar el hash de los datos del candidato ligados a su nombre
        ID_Candidato[_nombrePersona] = hash_Candidato;

        //Almacenamos el nombre del candidato
         candidatos.push(_nombrePersona);
    } 
        
        //Funcion para ver cuales personas se registraron como candidatos
    function VerCandidatos() public  view returns(string[] memory){

        //Devuelve la lista de los candidatos
        return candidatos;


    }

       //Las personas podran votar por los candidatos registrados
    function Votar(string memory _candidato) public{

        //Hash de la direccion de la persona que ejecuta la funcion
        bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));
        //Vericar si el votante no esta repetido
        for(uint i=0; i<votantes.length; i++){
            require(votantes[i]!=hash_Votante,"ya has votado previamente");

        }
        //almacenamos el hash dle votante dentro del array
        votantes.push(hash_Votante);
        //Anadimos un voto al candidato selecionado
        votos_Candidato[_candidato]++;
    }

        //Devuelve el numero de votos de un candidato
    function VerVotos(string memory _candidato) public view returns(uint ){
        return votos_Candidato[_candidato];

    }

    //Funcion auxiliar que transforma un uint a un string

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }


      //visualiza el conteo final de votos por candidato
    function VerResultados() public view returns(string memory ){
        string memory Resultados = "";
        
        for(uint i=0; i<candidatos.length; i++){
            Resultados = string(abi.encodePacked(Resultados, "(", candidatos[i], " , ", uint2str(VerVotos(candidatos[i])), " )----"));

        }
        return Resultados;

    }

    function Ganador() public view returns(string memory){

        string memory ganador = candidatos[0];
        bool flag;

        for(uint i=1; i<candidatos.length; i++){

            if(votos_Candidato[ganador] < votos_Candidato[candidatos[i]]){
                 ganador = candidatos[i];
                 flag = false;
            } else{
                if(votos_Candidato[ganador] == votos_Candidato[candidatos[i]]){
                    flag = true;
                }
            }
        }

        if(flag == true){
            ganador = "Hay un empate entre los canditados";
        }

        return ganador;

        
    }


}