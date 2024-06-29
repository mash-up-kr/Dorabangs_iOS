//
//  UINavigationController+NavigationBar.swift
//  Dorabangs
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
}
