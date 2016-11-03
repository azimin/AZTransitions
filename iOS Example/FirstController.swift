//
//  FirstController.swift
//  iOS Example
//
//  Created by Alex Zimin on 02/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

class FirstController: UIViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    segue.destination.az_modalTransition = FashionTransition()
  }
}

