//
//  ViewController.swift
//  BluetoothMessage
//
//  Created by Mac on 2024/1/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = ChatViewController(nibName: nil, bundle: nil)
        present(vc, animated: true)

    }

}

