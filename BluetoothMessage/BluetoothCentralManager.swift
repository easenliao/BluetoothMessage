
import CoreBluetooth
import Combine
protocol BluetoothCentralManagerDelegate: AnyObject {
    func bluetoothCentralManager(_ manager: BluetoothCentralManager, didReceiveMessage message: String)
    func didconnectPeripheral()
}
let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
class BluetoothCentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BluetoothCentralManager()
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?
    weak var delegate: BluetoothCentralManagerDelegate?
    @Published var peripherals = [CBPeripheral]()
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: [CBUUID(string: "12345678-1234-1234-1234-123456789ABC")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("發現Peripheral: \(peripheral.name ?? "")")
        // 檢查此周邊設備是否已經被發現並保存在陣列中
        if !peripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            peripherals.append(peripheral)
        }
//        discoveredPeripheral = peripheral
//        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已連接到Peripheral: \(peripheral.name ?? "")")
        central.stopScan()  // 停止掃描
        delegate?.didconnectPeripheral()
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "12345678-1234-1234-1234-123456789ABC")])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("發現Service: \(service.uuid)")
            //要開始找到特徵碼
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        //發現特徵開始讀取或者訂閱
        print("發現Characteristics: \(service.characteristics?.count ?? 0)")
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //讀取到特徵值
        guard let data = characteristic.value else { return }
        let message = String(data: data, encoding: .utf8) ?? ""
        print("hey you got message",message)
        delegate?.bluetoothCentralManager(self, didReceiveMessage: message)
        // Process the data
    }
}
extension BluetoothCentralManager {
    func startScanning() {
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "12345678-1234-1234-1234-123456789ABC")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    func connectPeripheral(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
}
