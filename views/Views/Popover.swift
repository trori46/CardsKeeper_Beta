//
//  Popover.swift
//  CardsKeeper
//
//  Created by Victoriia Rohozhyna on 11/9/17.
//  Copyright © 2017 Victoriia Rohozhyna. All rights reserved.
//

import Foundation
import UIKit

class Popover: UIViewController {
    var delegate : PopoverDelegate?
    
    @IBAction func az(_ sender: UIButton) {
        delegate?.pressedButton(sorted: .az)
        dismiss(animated: true, completion:  nil)
    }
    
    @IBAction func za(_ sender: UIButton) {
        delegate?.pressedButton(sorted: .za)
        dismiss(animated: true, completion:  nil)
    }
    
    @IBAction func dateUp(_ sender: UIButton) {
        delegate?.pressedButton(sorted: .dateUp)
        dismiss(animated: true, completion:  nil)

    }
    
    @IBAction func dateDown(_ sender: UIButton) {
        delegate?.pressedButton(sorted: .dateDown)
        dismiss(animated: true, completion:  nil)

    }
    
}

protocol PopoverDelegate {
    func pressedButton(sorted: PopoverButton)
}

enum PopoverButton {
    case az
    case za
    case dateUp
    case dateDown
}
