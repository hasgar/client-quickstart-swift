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
    
    func initializeTwilioDevice(_ token:String) {
        device = TCDevice.init(capabilityToken: token, delegate: self)
        self.dialButton.isEnabled = true
    }
    
    func retrieveToken() {
        // Create a GET request to the capability token endpoint
        let session = URLSession.shared
        
        let url = URL(string: TOKEN_URL)
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        let task = session.dataTask(with: request) { (responseData, response, error) in
            if let responseData = responseData {
                do {
                    let responseObject = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:String]
                    
                    if let identity = responseObject["identity"] {
                        DispatchQueue.main.async {
                            self.navigationItem.title = identity
                        }
                    }
                    
                    if let token = responseObject["token"] {
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
    
    func displayError(_ errorMessage:String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: TCDeviceDelegate
    func deviceDidStartListening(forIncomingConnections device: TCDevice) {
        statusLabel.text = "Started listening for incoming connections"

    }
    
    func device(_ device: TCDevice, didStopListeningForIncomingConnections error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    func device(_ device: TCDevice, didReceiveIncomingConnection connection: TCConnection) {
        if let parameters = connection.parameters {
            let from = parameters["From"]
            let message = "Incoming call from \(from)"
            let alertController = UIAlertController(title: "Incoming Call", message: message, preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Accept", style: .default, handler: { (action:UIAlertAction) in
                connection.delegate = self
                connection.accept()
                self.connection = connection
            })
            let declineAction = UIAlertAction(title: "Decline", style: .cancel, handler: { (action:UIAlertAction) in
                connection.reject()
            })
            alertController.addAction(acceptAction)
            alertController.addAction(declineAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func device(_ device: TCDevice, didReceivePresenceUpdate presenceEvent: TCPresenceEvent) {
        
    }
    
    
    
    //MARK: TCConnectionDelegate
    func connectionDidConnect(_ connection: TCConnection) {
        statusLabel.text = "Connected"
        hangUpButton.isEnabled = true
    }
    
    func connectionDidDisconnect(_ connection: TCConnection) {
        statusLabel.text = "Disconnected"
        dialButton.isEnabled = true
        hangUpButton.isEnabled = false
    }
    
    func connectionDidStartConnecting(_ connection: TCConnection) {
        statusLabel.text = "Started connecting...."
    }
    
    func connection(_ connection: TCConnection, didFailWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dial(dialTextField)
        dialTextField.resignFirstResponder()
        return true;
    }
    
    //MARK: IB Actions
    @IBAction func hangUp(_ sender: AnyObject) {
        if let connection = connection {
            connection.disconnect()
        }
    }
    
    @IBAction func dial(_ sender: AnyObject) {
        if let device = device {
            connection = device.connect(["To":dialTextField.text!], delegate: self)
            dialButton.isEnabled = false
            dialTextField.resignFirstResponder()
        }
    }
    
    


}

