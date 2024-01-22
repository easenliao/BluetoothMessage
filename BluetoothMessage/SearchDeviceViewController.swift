//
//  SearchDeviceViewController.swift
//  BluetoothMessage
//
//  Created by Mac on 2024/1/22.
//

import UIKit
import Combine
class SearchDeviceViewController: UIViewController {
    let bluetoothCentralManager = BluetoothCentralManager.shared
    let bluetoothPeripheralManager = BluetoothPeripheralManager.shared
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var isAdvertisingLabel: UILabel!
    
    @IBOutlet var isconnectedLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "DeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "DeviceTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        
        bluetoothCentralManager.$peripherals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableview.reloadData()
            }
            .store(in: &cancellables)
        bluetoothCentralManager.delegate = self
        bluetoothPeripheralManager.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func startAdvertisingAction(_ sender: Any) {
        bluetoothPeripheralManager.toggleAdvertising()
    }
    
    @IBAction func startScanningAction(_ sender: Any) {
        bluetoothCentralManager.startScanning()
    }

    @IBAction func sendTestMessage(_ sender: Any) {
        if  let data = "測試測試123".data(using: .utf8) {
            bluetoothPeripheralManager.sendData(data)
        }
    }
}
extension SearchDeviceViewController: BluetoothCentralManagerDelegate {
    func bluetoothCentralManager(_ manager: BluetoothCentralManager, didReceiveMessage message: String) {
        let vc = UIAlertController(title: "收到訊息", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        vc.addAction(action)
        self.present(vc, animated: true)
    }
    
    func didconnectPeripheral() {
        isconnectedLabel.text = "連線中"
    }
    
    
}
extension SearchDeviceViewController: BluetoothPeripheralManagerDelegate {
    func startAdvertising() {
        isAdvertisingLabel.text = "廣播中"
    }
    
    func stopAdvertising() {
        isAdvertisingLabel.text = "未開啟"
    }
    
    
}
extension SearchDeviceViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bluetoothCentralManager.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath) as! DeviceTableViewCell
        cell.deviceName.text = bluetoothCentralManager.peripherals[indexPath.row].name ?? "未知名稱"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bluetoothCentralManager.connectPeripheral(bluetoothCentralManager.peripherals[indexPath.row])
    }
}
