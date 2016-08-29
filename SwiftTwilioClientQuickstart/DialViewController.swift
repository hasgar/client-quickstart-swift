//
//  DialViewController.swift
//  SwiftTwilioClientQuickstart
//
//  Created by Jeffrey Linwood on 8/26/16.
//  Copyright © 2016 Twilio, Inc. All rights reserved.
//

import UIKit


class DialViewController: UIViewController,
    TCDeviceDelegate, TCConnectionDelegate, UITextFieldDelegate {
    
    let TOKEN_URL = "TOKEN_URL"
    
    var device:TCDevice?
    var connection:TCConnection?
    
    //MARK: IB Outlets
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dialTextField: UITextField!
    @IBOutlet weak var hangUpButton: UIButton!
    @IBOutlet weak var dialButton: UIButton!
    

    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveToken()
        navigationItem.title = "Quickstart"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initialization methods
    
    func initializeTwilioDevice(token:String) {
        device = TCDevice.init(capabilityToken: token, delegate: self)
        self.dialButton.enabled = true
    }
    
    func retrieveToken() {
        // Create a GET request to the capability token endpoint
        let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: TOKEN_URL)
        let request = NSURLRequest(URL: url!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30.0)
        
        
        let task = session.dataTaskWithRequest(request) { (responseData:NSData?, response:NSURLResponse?, error:NSError?) in
            if let responseData = responseData {
                do {
                    let responseObject = try NSJSONSerialization.JSONObjectWithData(responseData, options: [])
                    
                    if let identity = responseObject["identity"] as? String{
                        dispatch_async(dispatch_get_main_queue()) {
                            self.navigationItem.title = identity
                        }
                    }
                    
                    if let token = responseObject["token"] as? String {
                        self.initializeTwilioDevice(token)
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            } else if let error = error {
                self.displayError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //MARK: Utility Methods
    
    func displayError(errorMessage:String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: TCDeviceDelegate
    
    func device(device:TCDevice, didStopListeningForIncomingConnections:NSError?) {
        if let error = didStopListeningForIncomingConnections {
            print(error.localizedDescription)
        }
    }

    func deviceDidStartListeningForIncomingConnections(device: TCDevice) {
        statusLabel.text = "Started listening for incoming connections"
    }
    
    func device(device: TCDevice, didReceiveIncomingConnection connection: TCConnection) {
        if let parameters = connection.parameters {
            let from = parameters["From"]
            let message = "Incoming call from \(from)"
            let alertController = UIAlertController(title: "Incoming Call", message: message, preferredStyle: .Alert)
            let acceptAction = UIAlertAction(title: "Accept", style: .Default, handler: { (action:UIAlertAction) in
                connection.delegate = self
                connection.accept()
                self.connection = connection
            })
            let declineAction = UIAlertAction(title: "Decline", style: .Cancel, handler: { (action:UIAlertAction) in
                connection.reject()
            })
            alertController.addAction(acceptAction)
            alertController.addAction(declineAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: TCConnectionDelegate
    func connection(connection: TCConnection, didFailWithError:NSError?) {
        if let error = didFailWithError {
            print(error.localizedDescription)
        }
    }
    
    func connectionDidStartConnecting(connection: TCConnection) {
        statusLabel.text = "Started connecting...."
    }
    
    func connectionDidConnect(connection: TCConnection) {
        statusLabel.text = "Connected"
        hangUpButton.enabled = true
    }
    
    func connectionDidDisconnect(connection: TCConnection) {
        statusLabel.text = "Disconnected"
        dialButton.enabled = true
        hangUpButton.enabled = false
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dial(dialTextField)
        dialTextField.resignFirstResponder()
        return true;
    }
    
    //MARK: IB Actions
    @IBAction func hangUp(sender: AnyObject) {
        if let connection = connection {
            connection.disconnect()
        }
    }
    
    @IBAction func dial(sender: AnyObject) {
        if let device = device {
            device.connect(["To":dialTextField.text!], delegate: self)
            dialButton.enabled = false
            dialTextField.resignFirstResponder()
        }
    }
    
    


}

