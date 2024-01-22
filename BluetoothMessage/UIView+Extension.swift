//
//  UIView+Extension.swift
//  BluetoothMessage
//
//  Created by Mac on 2024/1/22.
//

import Foundation
import UIKit
extension UIView {
    @discardableResult
    func loadViewFromNib() -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        guard let contentView = Bundle(for: Self.self).loadNibNamed("\(Self.self)", owner: self, options: nil)?.first as? UIView else {
            fatalError("could not find nib file with name: \(Self.self)")
        }
        contentView.fill(on: self)
        return contentView
    }

    func fill(on superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        NSLayoutConstraint.activate([
            superView.topAnchor.constraint(equalTo: topAnchor),
            superView.bottomAnchor.constraint(equalTo: bottomAnchor),
            superView.leadingAnchor.constraint(equalTo: leadingAnchor),
            superView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
