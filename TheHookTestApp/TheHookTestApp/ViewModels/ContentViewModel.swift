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
    
    func updateTestString4(){
        testString = "Testing the test"
    }
    
    func updateTestString5(){
        testString = "Testing the test"
    }
    
    func updateTestString6(){
        testString = "Testing the test"
    }
    
    func updateTestString7(){
        testString = "Testing the test"
    }
    
    func updateTestString8(){
        testString = "Testing the test"
    }
    
    func printTest(){
        if !testString.isEmpty{
            print("\(testString)")
        }
    }
    
    func printTest2(){
        if !testString.isEmpty{
            print("\(testString)")
        }
    }
    
    func printTest3(){
        if !testString.isEmpty{
            print("\(testString)")
        }
    }
    
    func printTest4(){
        if !testString.isEmpty{
            print("\(testString)")
        }
    }
    
    func printTest5(){
        if !testString.isEmpty{
            print("\(testString)")
        }
    }
}
