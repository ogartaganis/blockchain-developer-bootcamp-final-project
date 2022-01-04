pragma solidity >=0.6.0 <0.9.0;

contract Vaccinator {
    struct VaccinatedPerson {
        bytes32 name;
        bytes vaccineSerialNumber;
    }

    // There are a few addresses that are allowed to verify a QR code
    mapping(address => bool) verifiers;
    // mapping(address => VaccinatedPerson) vaccinatedPeople;
    // The single source of truth is the vaccine serial number. It's unique and has to be contained in 
    // the Health Organization's database. Somehow.
    mapping(string => string) vaccineSerialNumbersAndNamesMapping;

    event LogDebug(string something);
    event LogSuccess(string qrCode);

    // constructor(address[] memory _verifiers, string[] memory _legitVaccineSerialNumbers){
    constructor(){
        address[1] memory _verifiers = [0xdeACE1bdAAbED5A7D1481e0EfB60418A50633CB5];
        string[5] memory _legitVaccineSerialNumbers = ["11", "12", "13", "14", "15"];

        // All the initial addresses should be verifiers
        for(uint i = 0; i < _verifiers.length; i++) {
            verifiers[_verifiers[i]] = true;
        }

        // All the initial vaccination serial numbers are legit and are initialized to "-" name
        for(uint i = 0; i < _legitVaccineSerialNumbers.length; i++) {
            vaccineSerialNumbersAndNamesMapping[_legitVaccineSerialNumbers[i]] = "-";
        }
    }

    // ********** OWNABLE ************ //
    address private owner = msg.sender; 

    modifier onlyOwner  {
        require(msg.sender == owner);
        _;
    }
    // /********* OWNABLE ***********/ //

    // No need to overcharge; checking that the user is only registered once
    // modifier onlyRegisterOnce(address _personAddress) {
    //     require(vaccinatedPeople[_personAddress].name.length == 0);
    //     _;
    // }

    // Our super-users; checking that only super users can verify
    modifier onlyVerifiers(address _verifierAddress) {
        require(verifiers[_verifierAddress]);
        _;
    }

    
    // modifier onlyLegitVaccineSerialNumbers(string memory serialNumber) {
    //     // require(keccak256(abi.encode(vaccineSerialNumbersAndNamesMapping[serialNumber])) == keccak256("-"));
    //     require(keccak256(abi.encode(vaccineSerialNumbersAndNamesMapping[serialNumber])) == keccak256(abi.encode('-')));
    //     emit LogDebug("not legit serial number!");
    //     _;
    // }

    // Let's think about it coz should the admin have to pay to register new verifiers?
    function addVerifier(address newVerifier) public onlyOwner payable {
        verifiers[newVerifier] = true;
    }

    /// @param name Their name
    /// @param vaccineSerialNumber A legit vaccine serial number
    // Register Vaccinated Person
    function registerVaccinatedPerson(string memory name, string memory vaccineSerialNumber) public payable returns (string memory qrCode){
        /**
        * Our legit vaccine serial numbers; checking that only these serial numbers are acceptable
        * They must: 
        *  a) be in the list
        *  b) be so far unclaimed          
        */
        if (keccak256(abi.encode(vaccineSerialNumbersAndNamesMapping[vaccineSerialNumber])) != keccak256(abi.encode('-'))) {
            emit LogDebug("not legit serial number!");
            // revert();
        } else {
            // QRCode string is produced and returned
            qrCode = produceQRCodeText(vaccineSerialNumber);
            emit LogSuccess(qrCode);

            // The object with the QRCode is stored as a struct
            vaccineSerialNumbersAndNamesMapping[vaccineSerialNumber] = name;
        }
    }

    /// @param qrCode The incoming QR code containing all the necessary info to approve
    // Somehow we need to verify that this person is registered
    function verifyRegisteredPerson(string memory qrCode) public view onlyVerifiers(msg.sender) returns (string memory name){
        // decode qrCode and produce the serialNumber!
        string memory serialNumber = getSlice(0, 9, qrCode);

        // Serial number should be legit
        name = vaccineSerialNumbersAndNamesMapping[serialNumber];
        
        // Should Emit the result
    }

    function produceQRCodeText(string memory serialNumber) pure private returns(string memory qrCodeString) {
        qrCodeString = string(abi.encodePacked(serialNumber, "pasok"));
    }

    // function decodeQRCodeText(bytes memory qrCodeString) pure private returns(string memory name) {
    //     name = string(abi.encodePacked(serialNumber, "pasok"));
    // }

    function getSlice(uint256 begin, uint256 end, string memory text) pure private returns (string memory) {
        bytes memory a = new bytes(end-begin+1);
        for(uint i=0;i<=end-begin;i++){
            a[i] = bytes(text)[i+begin-1];
        }
        return string(a);    
    }

    function string_tobytes(string memory s) pure private returns (bytes memory){
        bytes memory b3 = bytes(s);
        return b3;
    }
}