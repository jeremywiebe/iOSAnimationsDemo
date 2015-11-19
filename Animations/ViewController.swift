//
//  ViewController.swift
//  Animations
//
//  Created by Jeremy Wiebe on 2015-11-03.
//  Copyright © 2015 Mobify. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var simpleButton: UIButton!
    @IBOutlet weak var autolayoutButton: UIButton!
    @IBOutlet weak var easingButton: UIButton!
    @IBOutlet weak var easingTypeSegmentedControl: UISegmentedControl!

    var flipButtonPosition = CGPoint(x: 0, y: 0)

    override func viewDidLoad() {
        let constraintsCopy = view.constraints
        for c in constraintsCopy {
            if (c.firstItem as? NSObject == easingTypeSegmentedControl || c.secondItem as? NSObject == easingTypeSegmentedControl) {
                view.removeConstraint(c)
            }
        }

        let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[segment]-|", options: [], metrics: nil, views: ["segment": easingTypeSegmentedControl])
        view.addConstraints(widthConstraints)

        let topConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-[segment]", options: [], metrics: nil, views: [
            "button": easingButton,
            "segment": easingTypeSegmentedControl
        ])
        view.addConstraints(topConstraints)

        flipButtonPosition = flipButton.layer.position
    }

    @IBAction func handleFlipButtonTapped(sender: UIButton) {
        let reservedBits = 0b110

        if sender.tag & reservedBits == 0 {
            UIView.transitionWithView(flipButton, duration: 0.75,
                options: [UIViewAnimationOptions.TransitionFlipFromTop],
                animations: { () -> Void in
                },
                completion: { (completed) -> Void in

                }
            )
            sender.tag |= (0b1 << 1)
        } else if sender.tag & reservedBits == (0b1 << 1) {
            UIView.transitionWithView(flipButton, duration: 0.75,
                options: [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.TransitionFlipFromTop],
                animations: { () -> Void in
                },
                completion: { (completed) -> Void in

                }
            )

            sender.tag |= (0b1 << 2)
        } else if sender.tag & reservedBits == reservedBits {
            sender.layer.anchorPoint = CGPoint(x: 1, y: 1)
            sender.layer.position = CGPoint(
                x: flipButtonPosition.x + (sender.layer.bounds.width / 2),
                y: flipButtonPosition.y + (sender.layer.bounds.height / 2)
            )
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0
            animation.toValue = M_PI * 2
            animation.duration = 1.5
            sender.layer.addAnimation(animation, forKey: nil)

            sender.tag &= (Int.max - reservedBits) // Clear all but 2nd and 3rd bit placeholder
        }
    }


















































    @IBAction func handleSimpleButtonTapped(sender: UIButton) {
        UIView.animateWithDuration(1.0) {
            self.moveButton(self.simpleButton)
        }
    }
















































    @IBAction func handleEasingButtonTapped(sender: UIButton) {
        var easing: UIViewAnimationOptions
        switch easingTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            easing = UIViewAnimationOptions.CurveEaseIn
        case 1:
            easing = UIViewAnimationOptions.CurveEaseInOut
        case 2:
            easing = UIViewAnimationOptions.CurveEaseOut
        case 3:
            easing = UIViewAnimationOptions.CurveLinear
        default:
            fatalError()
        }

        UIView.animateWithDuration(0.5, delay: 0, options: easing,
            animations: {
                self.moveButton(self.easingButton)
            },
            completion: { (Bool) -> Void in })
    }










































    @IBAction func handleCASimpleButtonTapped(sender: UIButton) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.toValue = view.bounds.width - sender.frame.size.width - sender.frame.origin.x
        animation.duration = 2.0

        sender.layer.addAnimation(animation, forKey: "simple")
    }

















































    @IBAction func handleAroundTheHornButtonTapped(sender: UIButton) {
        let keyTimes = [0, 0.1, 0.4, 0.6, 0.9, 1]
        let timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        ]

        let halfButtonWidth = sender.layer.bounds.width / 2
        let xAnimation = CAKeyframeAnimation(keyPath: "position.x")
        xAnimation.values = [sender.layer.position.x, halfButtonWidth, halfButtonWidth, view.bounds.width - halfButtonWidth, view.bounds.width - halfButtonWidth, sender.layer.position.x]
        xAnimation.keyTimes = keyTimes
        xAnimation.duration = 4
        xAnimation.timingFunctions = timingFunctions
        sender.layer.addAnimation(xAnimation, forKey: nil)

        let halfButtonHeight = sender.layer.bounds.height / 2
        let yAnimation = CAKeyframeAnimation(keyPath: "position.y")
        yAnimation.values = [sender.layer.position.y,halfButtonHeight, view.bounds.height - halfButtonHeight, view.bounds.height - halfButtonHeight, 0, sender.layer.position.y]
        yAnimation.keyTimes = keyTimes
        yAnimation.duration = 4
        yAnimation.timingFunctions = timingFunctions
        sender.layer.addAnimation(yAnimation, forKey: nil)
    }

    func moveButton(button: UIButton) {
        var newFrame = button.frame

        newFrame.origin.x = view.bounds.width
            - button.frame.width
            - button.frame.origin.x

        button.frame = newFrame
    }
}
