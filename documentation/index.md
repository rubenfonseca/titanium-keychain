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

### keychain.getPasswordForService(service, account, [options])

This method gets a password from the iOS keychain. Both parameters are required

service[string]: the name of the service you are getting the password
account[string]: the account identifier
options[object, optional]: see section "advanced keychain options" bellow

This method returns _null_ if there are no login information for the parameters.

Example:

    var pass = keychain.getPasswordForService('twitter', 'root@cpan.org');

### keychain.setPasswordForService(password, service, account, [options])

Stores a password for the service/account pair. All parameters are required,
except for `options` (see section "advanced keychain options" bellow).

Example:

      var passwordField = Ti.UI.createTextField({ ... });

      # then later...
      keychain.setPasswordForService(passwordField.value, 'twitter', 'root@cpan.org');

### keychain.deletePasswordForService(service, account, [options])

Deletes the password for the service/account pair. Does nothing if there's no
login information for that pair.
See "advanced keychain options" bellow for the `options` param.

Example:

    var deleteButton = Ti.UI.createButton({ .... })

    deleteButton.addEventListener('click', function(e) {
      keychain.deletePasswordForService('twitter', 'root@cpan.org');
      alert('done :)');
    });

## Usage

For a full example, check the examples/app.js file.

## Advanced Keychain Options

Since version 2.0 of the module, evey call (get, set, delete) accepts an optional object
at the end, that allows to set specific advanced flags on the iOS Keychain. Specifically,
we support the `accesible` and `access_group` options.

**VERY VERY IMPORTANT**: since these advanced features requires the presence of a signed app 
and a secure hardware device, these advanced options will **not work** on the Simulator. You
need to use a real iOS device to test and use them! Usage of these options on the Simulator
will lead to undefined behaviour.

### Accessible

Use this option to indicate when your application needs access to the data in a keychain item.
You should choose the most restrictive option that meets your application's needs so that iOS
can protect that item to the greatest extent possible.

The available options for the `accessible` key are:

- keychain.ATTR_ACCESSIBLE_WHEN_UNLOCKED
> The data in the keychain item can be accessed only while the device is
>  unlocked by the user. This is recommended for items that need to be accessible
>  only while the application is in the foreground. Items with this attribute
>  migrate to a new device when using encrypted backups.

- keychain.ATTR_ACCESSIBLE_WHEN_UNLOCKED_THIS_DEVICE_ONLY
> The data in the keychain item can be accessed only while the device is
> unlocked by the user. This is recommended for items that need to be accesible
> only while the application is in the foreground. Items with this attribute do
> not migrate to a new device or new installation. Thus, after restoring from a
> backup, these items will not be present.

- keychain.ATTR_ACCESSIBLE_AFTER_FIRST_UNLOCK
> The data in the keychain item cannot be accessed after after a restart until
> the device has been unlocked once by the user. After the first unlock, the
> data remains accessible until the next restart. This is recommended for items
> that need to be accessed by background applications. Items with this
> attribute migrate to a new device when using encrypted backups.

- keychain.ATTR_ACCESSIBLE_AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY
> The data in the keychain item cannot be accessed after after a restart until
> the device has been unlocked once by the user. After the first unlock, the
> data remains accessible until the next restart. This is recommended for items
> that need to be accessed by background applications. Items with this
> attribute do not migrate to a new device or new installation. Thus, after
> restoring from a backup, these items will not be present.

- keychain.ATTR_ACCESSIBLE_ALWAYS
> The data in the keychain item can always be accessed regardless of whether
> the device is locked. This is not recommended for application use. Items with
> this attribute migrate to a new device when using encrypted backups. This is also
> the default option.

- keychain.ATTR_ACCESSIBLE_ALWAYS_THIS_DEVICE_ONLY
> The data in the keychain item can always be accessed regardless of whether
> the device is locked. This is not recommended for application use. Items with
> this attribute do not migrate to a new device or new installation. Thus,
> after restoring from a backup, these items will not be present.

Example:

    var sharekit = require('com.0x82.sharekit');
    sharekit.setPasswordForService('password', 'service', 'account', {
      accessible: sharekit.ATTR_ACCESSIBLE_ALWAYS_THIS_DEVICE_ONLY
    });

    sharekit.getPasswordForService('service', 'account', {
      accessible: sharekit.ATTR_ACCESSIBLE_ALWAYS_THIS_DEVICE_ONLY
    });

### Access Group

Access groups can be used to share keychain items among two or more
applications. For applications to share a keychain item, the applications must
have a common access group listed in their keychain-access-groups entitlement,
and the application adding the shared item to the keychain must specify this
shared access-group name as the value for this key in the dictionary passed to
the get/set/delete function.

The main pre-requisite for shared keychain access is that all of the applications 
have a *common bundle seed ID*. To be clear what this means, remember that an App ID
consists for two parts:

    <bundle seed ID>.<Bundle Identifier>

The bundle seed ID is a unique (within the App Store) ten character string that is
generated by Apple when you first create an App ID. The bundle identifier is generally set
to be a reverse domain string identifying your app (e.g. `com.yourcompany.appName`) and is what
you specify in the application `Info.plist` in Xcode.

So when you want to create an app that can share keychain access with an
existing app you need to make sure that you use the bundle seed ID of the
existing app. You do this when you create the new App ID in the iPhone
Provisioning Portal. Instead of generating a new value you select the existing
value from the list of all your previous bundle seed IDs.

One caveat, whilst you can create a provisioning profile with a wildcard for
the bundle identifier I have never been able to get shared keychain access
working between apps using it. It works fine with fully specified (no wildcard)
identifiers. Since a number of other Apple services such as push notifications
and in-app purchase also have this restriction maybe it should not be a
surprise but I am yet to find this documented for keychain access.

Once you have your provisioning profiles setup with a common bundle seed ID the
rest is pretty easy. The first thing you need to do is register the keychain
access group you want to use. The keychain access group can be named pretty
much anything you want as long as it starts with the bundle seed ID. So for
example if I have two applications as follows:

* ABC1234DEF.com.useyourloaf.amazingApp1
* ABC1234DEF.com.useyourloaf.amazingApp2

I could define a common keychain access group as follows:

* ABC1234DEF.amazingAppFamily

To enable this application to access this group you need to add an `Entitlements.plist`
file to the root of your Titanium Project. Create a new file called `Entitlements.plist`
and using a text editor, add the following:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>keychain-access-groups</key>
    	<array>
    		<string>ABC1234DEF.amazingAppFamily</string>
    	</array>
    </dict>
    </plist>

This same process should be repeated for all apps that share the bundle seed ID
to enable them to access the keychain group. To actually store and retrieve
values from this group requires an additional key on the get/set/delete function call:

    var sharekit = require('com.0x82.sharekit');
    sharekit.setPasswordForService('password', 'service', 'account', {
      access_group: "ABC1234DEF.amazingAppFamily"
    });

    sharekit.getPasswordForService('service', 'account', {
      access_group: "ABC1234DEF.amazingAppFamily"
    });

One final comment, using a shared keychain access group does not stop you from
storing values in an applications private keychain as well.

## Author

Ruben Fonseca, root (at) cpan (dot) org

You can also find me on [github](http://github.com/rubenfonseca) and on my
[blog](http://blog.0x82.com)

## License

This module is licensed under the MIT License. Please see the LICENSE file for
details

