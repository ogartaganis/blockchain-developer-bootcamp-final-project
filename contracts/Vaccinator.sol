pragma solidity >=0.4.22 <0.9.0;

contract Vaccinator {
    struct VaccinatedPerson {
        bytes32 name;
        bytes vaccineSerialNumber;
    }

    // There are a few addresses that are allowed to verify a QR code
    mapping(address => bool) verifiers;
    mapping(address => VaccinatedPerson) vaccinatedPeople;
    // The single source of truth is the vaccine serial number. It's unique and has to be contained in 
    // the Health Organization's database. Somehow.
    mapping(bytes => bool) legitVaccineSerialNumbers;

    // No need to overcharge
    modifier onlyRegisterOnce(address _personAddress) {
        require(vaccinatedPeople[_personAddress].name.length == 0);
        _;
    }

    // Our super-users
    modifier onlyVerifiers(address _verifierAddress) {
        require(verifiers[_verifierAddress]);
        _;
    }

    // Our legit vaccine serial numbers
    modifier onlyLegitVaccineSerialNumbers(bytes memory serialNumber) {
        require(legitVaccineSerialNumbers[serialNumber]);
        _;
    }

    constructor(address[] memory _verifiers){
        // All the initial addresses should be verifiers
        for(uint i = 0; i < _verifiers.length; i++) {
            verifiers[_verifiers[i]] = true;
        }
    }

    // Register Vaccinated Person
    function registerVaccinatedPerson(address _vaccinated, bytes32 name, bytes memory vaccineSerialNumber) public payable onlyRegisterOnce(_vaccinated) onlyLegitVaccineSerialNumbers(vaccineSerialNumber) returns (string memory qrCode){
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