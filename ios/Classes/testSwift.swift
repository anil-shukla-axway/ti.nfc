//
//  testSwift.swift
//  ti.nfc
//
//  Created by Anil Shukla on 18/12/20.
//

import UIKit

class testSwift: NSObject {

    @objc func printStr() -> String{
            name()
         return "Testing pass"
     }
    
    @objc func name(){
        let someStr = "Winning is good"
        let data = Data(someStr.utf8)
        TiNfcUtilities.type(fromNDEFData: data)
    }
}
