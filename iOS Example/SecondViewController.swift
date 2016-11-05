//
//  SecondViewController.swift
//  iOS Example
//
//  Created by Alex Zimin on 02/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
  
  @IBOutlet weak var closeButton: UIButton! {
    didSet {
      closeButton.underlineCurrentTitle()
    }
  }
  
  @IBAction func closeButtonAction(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
}
