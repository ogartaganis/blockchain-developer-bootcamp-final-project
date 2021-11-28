console.log("FORTWTHIKE")

// 1. detect Metamask is/is not installed
window.addEventListener('load', function() {
    if (typeof window.ethereum !== 'undefined'){
        console.log('MetaMask detected!')
        // document refers to the html file
        let mmDetected = document.getElementById('mm-detected')
        mmDetected.innerHTML = "MetaMask Has Been Detected!"
    } else {
        console.group('MetaMask Not Available!')
        alert("You need to install MetaMask or another wallet!")
    }
})

const mmEnable = document.getElementById('mm-connect');

// 2. allow the user to get access to Metamask3.
mmEnable.onclick = async() => {
    console.log("asdfff")
    await ethereum.request({ method: 'eth_requestAccounts'})

    const mmCurrentAccount = document.getElementById('mm-current-account');
    mmEnable.style.visibility='hidden';

    mmCurrentAccount.innerHTML = "Here's your current account: <br />"+ethereum.selectedAddress
}