# keychain Module

## Description

This Titanium Module allows you to interact with the iOS Keychain in
a tidy and simple way. This allows you to securely store and retrieve login 
information for a specific service and account.

## Installation

[http://wiki.appcelerator.org/display/tis/Using+Titanium+Modules]()

## Changelog

See [here](changelog.html)

## Accessing the keychain Module

To access this module from JavaScript, you would do the following:

	var keychain = require("com.0x82.key.chain");

The keychain variable is a reference to the Module object.	

## Reference

### keychain.getPasswordForService(service, account)

This method gets a password from the iOS keychain. Both parameters are required

service[string]: the name of the service you are getting the password
account[string]: the account identifier

This method returns _null_ if there are no login information for the parameters.

Example:

    var pass = keychain.getPasswordForService('twitter', 'root@cpan.org');

### keychain.setPasswordForService(password, service, account)

Stores a password for the service/account pair. All parameters are required

Example:

      var passwordField = Ti.UI.createTextField({ ... });

      # then later...
      keychain.setPasswordForService(passwordField.value, 'twitter', 'root@cpan.org');

### keychain.deletePasswordForService(service, account)

Deletes the password for the service/account pair. Does nothing if there's no
login information for that pair.

Example:

    var deleteButton = Ti.UI.createButton({ .... })

    deleteButton.addEventListener('click', function(e) {
      keychain.deletePasswordForService('twitter', 'root@cpan.org');
      alert('done :)');
    });

## Usage

For a full example, check the examples/app.js file.

## Author


Ruben Fonseca, root (at) cpan (dot) org

You can also find me on [github](http://github.com/rubenfonseca) and on my
[blog](http://blog.0x82.com)

## License

This module is licensed under the MIT License. Please see the LICENSE file for
details

