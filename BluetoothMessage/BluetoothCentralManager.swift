
import CoreBluetooth
let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
class BluetoothCentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "12345678-1234-1234-1234-123456789ABC")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // 这里可以添加逻辑以确定是否要连接到该外围设备
        // 例如，检查设备名称或服务
        print("发现外围设备: \(peripheral.name ?? "")")
        discoveredPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("已连接到外围设备: \(peripheral.name ?? "")")
        central.stopScan()  // 停止扫描
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "12345678-1234-1234-1234-123456789ABC")])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("发现服务: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
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
        guard let data = characteristic.value else { return }
        let message = String(data: data, encoding: .utf8) ?? ""
        print("hey you got message",message)
        // Process the data
    }
}
extension BluetoothCentralManager {
    func startScanning() {
        centralManager.scanForPeripherals(withServices: [CBUUID(string: "12345678-1234-1234-1234-123456789ABC")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
}
