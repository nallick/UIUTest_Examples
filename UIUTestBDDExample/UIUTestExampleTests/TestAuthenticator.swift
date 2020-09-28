//
//  TestAuthenticator.swift
//  UIUTestExampleTests
//
//  Created by thompsty on 9/28/20.
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

import Foundation
import UIUTestExample

struct TestAuthenticator: Authenticator
{
    static let validUser = "Test User"
    static let invalidUser = "Invalid User"
    static let validPassword = "Test Password"
    static let invalidPassword = "Invalid Password"
    
    func authenticate(user: String, password: String) -> Bool {
        return (user == TestAuthenticator.validUser && password == TestAuthenticator.validPassword)
    }
}
