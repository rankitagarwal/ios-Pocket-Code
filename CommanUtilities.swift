//
//  CommanUtilites.swift
//
//  Created by Rankit on 5/20/16.
//  Copyright © 2020 Rankit. All rights reserved.
//

import Foundation
import UIKit

class CommanUtilities
{
    
    static let sharedInstance = CommanUtilities()//Singleton instance of the class.
    
    func displayAlert(_ title:String, message andMessage:String,presentingController controller:UIViewController)
    {
        let alert:UIAlertController = UIAlertController.init(title: title, message: andMessage, preferredStyle: .alert)
        controller.present(alert, animated: true, completion: nil)
    }
    
    
    
}
