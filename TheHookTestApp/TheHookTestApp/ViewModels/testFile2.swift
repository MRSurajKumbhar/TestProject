//
//  testFile2.swift
//  TheHookTestApp
//
//  Created by Suraj Kumbhar on 10/05/26.
//

import SwiftUI
import Combine

class testFile2 : ObservableObject {
    @Published var testFile2String : String = ""
    
    func updateTestStringtestFile2(){
        testFile2String = "Testing the test"
    }
}
