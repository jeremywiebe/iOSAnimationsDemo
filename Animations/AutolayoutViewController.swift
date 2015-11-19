//
//  AutolayoutViewController.swift
//  Animations
//
//  Created by Jeremy Wiebe on 2015-11-03.
//  Copyright © 2015 Mobify. All rights reserved.
//

import Foundation
import UIKit

class AutolayoutViewController: UIViewController {
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    @IBAction func handleSimpleButtonTapped(sender: UIButton) {
        // Ensure any pending layout operations are completed
        self.view.layoutIfNeeded()

        UIView.animateWithDuration(1) {
            if self.view.constraints.contains(self.trailingConstraint) {
                self.view.removeConstraint(self.trailingConstraint)
                self.view.addConstraint(self.leadingConstraint)
            } else {
                self.view.removeConstraint(self.leadingConstraint)
                self.view.addConstraint(self.trailingConstraint)
            }

            self.view.layoutIfNeeded()
        }
    }
}