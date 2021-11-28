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

function openRole(evt, role) {
    // Declare all variables
    var i, tabcontent, tablinks;
  
    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
    }
  
    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
  
    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(role).style.display = "block";
    evt.currentTarget.className += " active";
  } 

  // ************* Scanner ************* //
  var qrc = new QRCode(document.getElementById("qrcode"), "http://site.com/");

  function onScanSuccess(decodedText, decodedResult) {
    console.log(`Code scanned = ${decodedText}`, decodedResult);
    html5QrcodeScanner.stop();
    
    QRCode.stop;
}
// var html5QrcodeScanner = new Html5QrcodeScanner("qr-reader", { fps: 10, qrbox: 250 });
// html5QrcodeScanner.render(onScanSuccess);

// PRO mode
const html5QrCode = new Html5Qrcode("qr-reader");
// This method will trigger user permissions
var cameraId = "";
Html5Qrcode.getCameras().then(devices => {
    /**
     * devices would be an array of objects of type:
     * { id: "id", label: "label" }
     */
    if (devices && devices.length) {
      cameraId = devices[0].id;
      console.log("CAMERA ID: "+cameraId);
    }
  }).catch(err => {
    // handle err
  });
const startScanning = document.getElementById('qr-start-scanning');

// 2. allow the user to get access to Metamask3.
startScanning.onclick = async() => {
    html5QrCode.start(
        cameraId, 
        {
          fps: 10,    // Optional, frame per seconds for qr code scanning
          qrbox: { width: 250, height: 250 }  // Optional, if you want bounded box UI
        },
        (decodedText, decodedResult) => {
          console.log("DECODED TEXT : "+decodedText);
          html5QrCode.stop();
          alert("DECODED TEXT : "+decodedText);
        },
        (errorMessage) => {
          // parse error, ignore it.
        })
      .catch((err) => {
        // Start failed, handle it.
      });
}