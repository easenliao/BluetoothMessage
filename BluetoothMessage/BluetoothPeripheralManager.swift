import CoreBluetooth
protocol BluetoothPeripheralManagerDelegate: AnyObject {
    func startAdvertising()
    func stopAdvertising()
}
let characteristicUUID = CBUUID.init(nsuuid: UUID.init())
class BluetoothPeripheralManager: NSObject, CBPeripheralManagerDelegate {
    static let shared = BluetoothPeripheralManager()
    weak var delegate: BluetoothPeripheralManagerDelegate?
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
            transferCharacteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .notify, value: nil, permissions: .readable)
            let service = CBMutableService(type: serviceUUID, primary: true)
            service.characteristics = [transferCharacteristic!]
            peripheralManager.add(service)
        }
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("中央設備已經訂閱了特徵")
        // 停止廣播
        if peripheralManager.isAdvertising {
            delegate?.stopAdvertising()
            peripheralManager.stopAdvertising()
        }
    }
    // Call this method when you want to send data
    func sendData(_ data: Data) {
        peripheralManager.updateValue(data, for: transferCharacteristic!, onSubscribedCentrals: nil)
    }
    func toggleAdvertising() {
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [serviceUUID]])
        delegate?.startAdvertising()
        if peripheralManager.isAdvertising {
            peripheralManager.stopAdvertising()
            delegate?.stopAdvertising()
        }
    }
}
