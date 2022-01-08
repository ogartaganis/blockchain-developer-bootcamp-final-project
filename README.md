# blockchain-developer-bootcamp-final-project
Final project submission for the ConsenSys Academy Blockchain Developer Bootcamp 2021

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

As a result, they're receiving a QR code with a prompt to save or take a screenshot of.

< ___ IMAGE ___ >

### Verifying
Similar to the app in Fig.1, the reverse process is going to be used to verify the validity of the QR code, bringing back the name of the person that has registered said serial number. The one verifying then can check the ID that the person is going to be holding.

<img src="https://user-images.githubusercontent.com/5063813/135172098-a38dd1cc-3f02-4da2-b71f-c07255b2da70.png" width=400/><br />
Fig.1: The sample tool found via https://ethereum-101.netlify.app, from which the inspiration came

For the purpose of verification, we're using the camera of the device to `scan` the QR code that the user is showing to us.

< ___ IMAGE ___ >


## Implementation
- All the smart contract logic is contained in the `Vaccinator.sol` smart contract whereas there are two more contracts, the infamous `Migrations.sol` for.. migrations and the `Ownable.sol` contract to inherit the Ownable interface/ access control contract.

- The frontend is in the `index.html` file and is backed by our `dapp.js`, holding all the logic for the connection of it with the contract. The contract is included in the top of the file as an ABI, along with its *ROPSTEN* contract address.
  
- There's also a tiny `style.css` (insert gif with Peter Griffin playing with CSS).