//
//  UIViewController+Context.swift
//  ajudacidadao
//
//  Created by user204576 on 1/9/22.
//

import UIKit
import CoreData

extension UIViewController{
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainner.viewContext
    }
}
