//
//  FirstViewController.swift
//  iOS Example
//
//  Created by Alex Zimin on 02/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segue.destination.az_modalTransition = FashionTransition()
    
    // Use line below if you need FirstViewController to stay on screen after transition
    // segue.destination.setCustomModalTransition(az_modalTransition: FashionTransition(), inPresentationStyle: .overCurrentContext)
  }
}

