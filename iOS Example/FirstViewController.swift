//
//  FirstViewController.swift
//  iOS Example
//
//  Created by Alex Zimin on 02/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
  var isOverCurrentContextTransition = false
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if isOverCurrentContextTransition {
      segue.destination.setCustomModalTransition(customModalTransition: AlphaByStepTransition(), inPresentationStyle: .overCurrentContext)
    } else {
      segue.destination.customModalTransition = FashionTransition()
    }
  }
  
  @IBOutlet weak var showButton: UIButton! {
    didSet {
      showButton.underlineCurrentTitle()
    }
  }
  
  @IBAction func isOverTransitionSwiftAction(_ sender: UISwitch) {
    isOverCurrentContextTransition = sender.isOn
  }
}
