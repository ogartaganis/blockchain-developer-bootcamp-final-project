# blockchain-developer-bootcamp-final-project
Final project submission for the ConsenSys Academy Blockchain Developer Bootcamp 2021
```
Orestis Gartaganis
0xdeACE1bdAAbED5A7D1481e0EfB60418A50633CB5
```
Contract Address (ROPSTEN): `deployed_address.txt`file

Dapp frontend address: https://ogartaganis.github.io

Screencast: https://www.loom.com/share/4879977af16c4e058e02601eea70c488

## Project idea:

`tl;dr`: Validator for vaccination certficate

`longer version`: 
In these times but also others to follow, we need a way to validate whether a vaccination certificate issued is actually legitimate or not, in a trustless environment. 

## Concept
The interface has 2 modes:
- one for registering the certificate and
- one for validating it.

### Registering
As soon as one has their vaccination serial number (ie. that's the unique identifier of their vaccine), they will enter it in the Blockchain, along with their first and last name.

Registration is performed using the function:

```
function registerVaccinatedPerson(string memory name, string memory vaccineSerialNumber) public payable returns (string memory qrCode){ .. }
```

As a result, they're receiving a QR code with a prompt to save or take a screenshot of. `<dev> The QR Code is produced in the frontend. The Contract just returns a string</dev>`

<img width="1309" alt="image" src="https://user-images.githubusercontent.com/5063813/149139996-5e162ec9-07ab-415f-a113-24e7a90591d0.png">

ALSO! The UI is informing us how many legit serial numbers are left. Covers the "read from the smart contract" part of the requirements.

### Verifying
The reverse process is going to be used to verify the validity of the QR code, bringing back the name of the person that has registered said serial number. The one verifying then can check the ID that the person is going to be holding.

For the purpose of verification, we're using the camera of the device to `scan` the QR code that the user is showing to us. 

Verification is performed with the function:

```
function verifyRegisteredPerson(string memory serialNumber) public view onlyVerifiers(msg.sender) returns (string memory name){..}
```

<img width="1017" alt="image" src="https://user-images.githubusercontent.com/5063813/149141341-74e95c94-41e8-4395-955f-9b25015360c3.png">

<img width="991" alt="image" src="https://user-images.githubusercontent.com/5063813/149141183-942dcf64-f144-4eb6-9b10-a440be3efc32.png">



## Implementation
- All the smart contract logic is contained in the `Vaccinator.sol` smart contract whereas there are two more contracts, the infamous `Migrations.sol` for.. migrations and the `Ownable.sol` contract to inherit the Ownable interface/ access control contract.

- The frontend is in the `index.html` file and is backed by our `dapp.js`, holding all the logic for the connection of it with the contract. The contract is included in the top of the file as an ABI, along with its *ROPSTEN* contract address.
  
- There's also a tiny `style.css` (insert gif of Peter Griffin playing with CSS).

## Testing
All tests are found in the `vaccinator.test.js` and there's one more helper file, the `exceptions.js`, which can help with catching errors (equiped for **reverts** in this test suite).

## Deploying
The address and network of the contract can be found in the `deployed_address.txt` file.

There are no external dependencies, only internal, where you should also deploy `Ownable.sol`.

You can run as a local node on port: 7545.

## IMPORTANT
Since the verifiers is a sensitive group of people, they're defined in the constructor but also through a function that is `ownerOnly`. So if any of you wants to use the verification, you have the option to contact the owner (me) to add you. Or trust the tests - trust the screencast.

This is an MVP and as such it should be treated :)

If you read till here, you rock 🤙
