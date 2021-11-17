pragma solidity >=0.4.22 <0.9.0;

contract Vaccinator {

    // The single source of truth is the vaccine serial number. It's unique and has to be contained in 
    // the Health Organization's database. Somehow.
    bytes[] legitVaccineSerialNumbers =  [bytes("asdf"),bytes("fdas"),bytes("asdfasdf")];

    struct VaccinatedPerson {
        bytes32 name;
        uint vaccineSerialNumber;
    }

    mapping(address => bool) verifiers;
    mapping(address => VaccinatedPerson) vaccinatedPeople;

    modifier onlyRegisterOnce(address _personAddress) {
        require(vaccinatedPeople[_personAddress].name.length == 0);
        _;
    }

    modifier onlyVerifiers(address _verifierAddress) {
        require(verifiers[_verifierAddress]);
        _;
    }

    constructor(address[] memory _verifiers){
        // All the initial addresses should be verifiers
        for(uint i = 0; i < _verifiers.length; i++) {
            verifiers[_verifiers[i]] = true;
        }
    }

    // Register Vaccinated Person
    function registerVaccinatedPerson(address _vaccinated, bytes32 name, uint vaccineSerialNumber) public payable onlyRegisterOnce(_vaccinated) returns (string memory qrCode){
        // QRCode string is produced and returned
        qrCode = "12343124";

        // The object with the QRCode is stored as a struct
        vaccinatedPeople[_vaccinated] = VaccinatedPerson(name, vaccineSerialNumber);
    }

    // Somehow we need to verify that this person is registered
    function verifyRegisteredPerson(string memory qrCode) public view onlyVerifiers(msg.sender) returns (bytes32 name){
        // decode qrCode and produce the address!
        address toVerify = 0x0000000000000000000000000000000000000000;
        
        name = vaccinatedPeople[toVerify].name;
    }
}