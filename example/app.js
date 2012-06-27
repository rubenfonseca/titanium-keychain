// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
window.add(label);
window.open();

// load the keychain module
var keychain = require('com.0x82.key.chain');
Ti.API.info("module is => " + keychain);

// create three buttons to set, get, and delete passwords
var button1 = Ti.UI.createButton({
    title: 'set password',
    top: 20,
    width: 140,
    height: 30,
    left: 100
});

var button2 = Ti.UI.createButton({
  title: 'get password',
    top: 60,
    width: 140,
    height: 30,
    left: 100
});

var button3 = Ti.UI.createButton({
  title: 'delete password',
    top: 100,
    width: 140,
    height: 30,
    left: 100
});

var label = Ti.UI.createLabel({
  bottom: 10,
    width: '100%',
    height: 'auto',
    textAlign: 'center'
});

window.add(button1);
window.add(button2);
window.add(button3);
window.add(label);

button1.addEventListener('click', function(e) {
  var options = {
    accessible: keychain.ATTR_ACCESSIBLE_WHEN_UNLOCKED,
    access_group: "BW3GR862AK.com.0x82.key.chain"
  };

  keychain.setPasswordForService('abracadabra', 'service', 'account');

  label.text = 'Password setted';
});

button2.addEventListener('click', function(e) {
  var options = {
    accessible: keychain.ATTR_ACCESSIBLE_WHEN_UNLOCKED,
    access_group: "BW3GR862AK.com.0x82.key.chain"
  };

  var pass = keychain.getPasswordForService('service', 'account');
  alert(pass);
  label.text = '';
});

button3.addEventListener('click', function(e) {
  keychain.deletePasswordForService('service', 'account');
  label.text = 'Password deleted!';
});

