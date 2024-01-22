//
//  DeviceTableViewCell.swift
//  BluetoothMessage
//
//  Created by Mac on 2024/1/22.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet var deviceName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
