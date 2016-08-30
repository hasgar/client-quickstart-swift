# client-quickstart-swift

Twilio Client for iOS Quickstart using Swift

This application should give you a ready-made starting point for writing your
own voice-enabled apps with Twilio Client. Before we begin, you need to collect the credentials to run the Twilio Client Quickstart web app. 

Config Value | Description
---------- | -----------
Account SID | Your primary Twilio account identifier - find this [in the console here](https://www.twilio.com/console).
Auth Token | Used to authenticate - [just like the above, you'll find this here](https://www.twilio.com/console).
TwiML App SID | The TwiML application with a voice URL configured to access your server running this app - create one [in the console here](https://www.twilio.com/console/phone-numbers/dev-tools/twiml-apps). Also, you will need to configure the Voice "REQUEST URL" on the TwiML app once you've got your server up and running.
Twilio Phone # | A Twilio phone number in [E.164 format](https://en.wikipedia.org/wiki/E.164) - you can [get one here](https://www.twilio.com/console/phone-numbers/incoming)

Choose a download package for your server-side language of choice. If you're primarily a mobile app developer and don't have a strong preference, Node.js or Ruby will probably get you up and running the fastest.

- [Download for C#](https://github.com/TwilioDevEd/client-quickstart-csharp/archive/master.zip)
- [Download for Java](https://github.com/TwilioDevEd/client-quickstart-java/archive/master.zip)
- [Download for Node.js](https://github.com/TwilioDevEd/client-quickstart-node/archive/master.zip)
- [Download for PHP](https://github.com/TwilioDevEd/client-quickstart-php/archive/master.zip)
- [Download for Python](https://github.com/TwilioDevEd/client-quickstart-python/archive/master.zip)
- [Download for Ruby](https://github.com/TwilioDevEd/client-quickstart-ruby/archive/master.zip)

##Setting up the web app
Follow the instructions in the README for each starter application to configure and run it on your machine, using the four values we created above:

* [Instructions for C#](https://github.com/TwilioDevEd/client-quickstart-csharp)
* [Instructions for Java](https://github.com/TwilioDevEd/client-quickstart-java)
* [Instructions for Node.js](https://github.com/TwilioDevEd/client-quickstart-node)
* [Instructions for PHP](https://github.com/TwilioDevEd/client-quickstart-php)
* [Instructions for Python](https://github.com/TwilioDevEd/client-quickstart-python)
* [Instructions for Ruby](https://github.com/TwilioDevEd/client-quickstart-ruby)

Your application should now be running locally. 

## Host Your Server
Once you've got your server up and running, you will need to host it somewhere Twilio can access it. You can publish your app to a web hosting provider, or you can run it locally and use [ngrok](https://ngrok.com/) to create a tunnel to your development machine with a publicly accessible URL. See the README above for the specific ngrok instructions for your preferred platform.

## Configure Your TwiML App
Now, configure the Voice "REQUEST URL" on your TwiML App to hit the voice URL on your server. Again, see the README above for platform-specific instructions.


## Setting Up The iOS App

In the DialViewController.swift file, on this line,

    let TOKEN_URL = "TOKEN_URL"

Replace the URL with the address of your server, followed by /token, for instance, https://asdf456.ngrok.io/token

Last, go ahead and run `pod install` from your command line (install [Cocoapods](https://www.cocoapods.org/) if you don't already have it set up) to install the [Twilio Client SDK for iOS](https://www.twilio.com/docs/api/client/ios). Or if you prefer not to use Cocoapods, download the SDK and install the libraries and headers manually.

Go ahead and run your application, either in the Simulator, or on your device, and you should be up and running! You can make Twilio Client connections to other users of your quickstart server (find your identity in the nav bar), or make outgoing phone calls from the app.

## License

MIT
