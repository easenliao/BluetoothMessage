//
//  ChatViewController.swift
//  BluetoothMessage
//
//  Created by Mac on 2024/1/22.
//

import UIKit

class ChatViewController: UIViewController {

    var centralManager: BluetoothCentralManager?
    var peripheralManager: BluetoothPeripheralManager?

    @IBOutlet var messageTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = BluetoothCentralManager()
        peripheralManager = BluetoothPeripheralManager()
    }
    @IBAction func startScanning(_ sender: UIButton) {
        centralManager?.startScanning()
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        if let message = messageTextField.text, let data = message.data(using: .utf8) {
            peripheralManager?.sendData(data)
        }
    }

    @IBAction func startAdvertising(_ sender: Any) {
        peripheralManager?.toggleAdvertising()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
