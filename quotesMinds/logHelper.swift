//
//  logHelper.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

protocol logHelper {
    var logLevel: Int { get set }
}

extension logHelper {
    func println(str: String, level: Int){
        //let className : String = " \(self))".componentsSeparatedByString(".").last!.componentsSeparatedByString(":").first!
        var shouldPrint = false
        if(logLevel <= level){
            shouldPrint = true
        }
        if(shouldPrint){
          //  print("##  \(className) ::: level (\(logLevel)) \n  -->:{ \(str) }\n")
        }
    }

    func println(str: String){
        if(logLevel != 0){
        //let className : String = " \(self))".componentsSeparatedByString(".").last!.componentsSeparatedByString(":").first!
            //print("##  \(className) \n  -->:{ \(str) }\n")
        }
    }
  
}
