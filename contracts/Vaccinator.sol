// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

import "./Ownable.sol";

/// @title Validator for vaccination certficate
/// @author Orestis Gartaganis
/// @notice You can use this contract for only the most basic vaccination registration 
///         and verification. No encryption has been used and lots of them need improvment 
contract Vaccinator is Ownable{

    string[] private legitVaccineSerialNumbers;

    /// There are a few addresses that are allowed to verify a QR code
    mapping(address => bool) public verifiers;

    /// The single source of truth is the vaccine serial number. It's unique and has to be contained in 
    /// the Health Organization's database. Somehow.
    mapping(string => string) vaccineSerialNumbersAndNamesMapping;

    event LogFailure(string message);
    event LogSuccess(string message);

    constructor(address[] memory _verifiers, string[] memory _legitVaccineSerialNumbers){

        /// All the initial addresses should be verifiers
        for(uint i = 0; i < _verifiers.length; i++) {
            verifiers[_verifiers[i]] = true;
        }

        legitVaccineSerialNumbers = _legitVaccineSerialNumbers;

        /// All the initial vaccination serial numbers are legit and are initialized to "-" name
        for(uint i = 0; i < _legitVaccineSerialNumbers.length; i++) {
            vaccineSerialNumbersAndNamesMapping[_legitVaccineSerialNumbers[i]] = "-";
        }
    }

    /// Our super-users; checking that only super users can verify
    /// @param _verifierAddress the attempting verifier address
    /// @dev this will block anyone even starting a transaction if they can't,
    ///      saving them from getting charged
    modifier onlyVerifiers(address _verifierAddress) {
        require(verifiers[_verifierAddress]);
        _;
    }

    /// @notice Let's think about it coz should the owner have to pay to register new verifiers?
    function addVerifier(address newVerifier) public onlyOwner payable {
        verifiers[newVerifier] = true;
    }

    /// Register Vaccinated Person
    /// @param name Their name
    /// @param vaccineSerialNumber A legit vaccine serial number
    function registerVaccinatedPerson(string memory name, string memory vaccineSerialNumber) public payable returns (string memory qrCode){
        /**
        * Our legit vaccine serial numbers; checking that only these serial numbers are acceptable
        * They must: 
        *  a) be in the list
        *  b) be so far unclaimed          
        */
        if (keccak256(abi.encode(vaccineSerialNumbersAndNamesMapping[vaccineSerialNumber])) != keccak256(abi.encode('-'))) {
            emit LogFailure("not legit serial number!");
        } else {
            /// QRCode string is produced and returned
            qrCode = produceQRCodeText(vaccineSerialNumber);

            /// The inputted name is corresponded to the vaccineSerialNumber
            vaccineSerialNumbersAndNamesMapping[vaccineSerialNumber] = name;
            emit LogSuccess(qrCode);
        }
    }

    /// @param serialNumber The incoming serialNumber to check against our db
    /// Somehow we need to verify that this person is registered
    function verifyRegisteredPerson(string memory serialNumber) public view onlyVerifiers(msg.sender) returns (string memory name){
        /// // decode qrCode and produce the serialNumber!
        /// @dev this solution unfortunately charges us so if we want to have this 
        ///      function "view", we cannot do complicated stuff here.
        /// string memory serialNumber = getSlice(0, 1, qrCode);

        /// Let's return the name that corresponds and we check in the frontend whether it's a name or a gap
        name = vaccineSerialNumbersAndNamesMapping[serialNumber];
    }

    /// @notice We should come up with a better strategy for encryption
    ///         Currently we're adding a word here and then decrypting it in the frontend
    ///         But we can do better in a real-world scenario
    function produceQRCodeText(string memory serialNumber) pure private returns(string memory qrCodeString) {
        qrCodeString = string(abi.encodePacked(serialNumber, "pasok"));
    }

    // function getSlice(uint256 begin, uint256 end, string memory text) payable public returns (string memory) {
    //     bytes memory a = new bytes(end-begin+1);
    //     for(uint i=0;i<=end-begin;i++){
    //         a[i] = bytes(text)[i+begin-1];
    //     }
    //     return string(a);    
    // }

    function string_tobytes(string memory s) pure private returns (bytes memory){
        bytes memory b3 = bytes(s);
        return b3;
    }

    function numberOfSerialsLeft() public view returns (uint count) {
        count = 0;
        for(uint i = 0; i < legitVaccineSerialNumbers.length; i++) {
            if (keccak256(abi.encode(vaccineSerialNumbersAndNamesMapping[legitVaccineSerialNumbers[i]])) == keccak256(abi.encode('-'))){
                count += 1;
            }
        }
    }
}