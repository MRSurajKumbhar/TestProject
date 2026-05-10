//
//  ContentViewModel.swift
//  TheHookTestApp
//
//  Created by Suraj Kumbhar on 10/05/26.
//

import SwiftUI
import Combine

class ContentViewModel : ObservableObject {
    @Published var testString : String = ""
    
    func updateTestString(){
        testString = "Testing the test"
    }
    
    func updateTestString2(){
        testString = "Testing the test"
    }
    
    func updateTestString3(){
        testString = "Testing the test"
    }
}
