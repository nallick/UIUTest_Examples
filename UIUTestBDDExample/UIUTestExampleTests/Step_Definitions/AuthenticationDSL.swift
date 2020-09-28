//
//  AuthenticationDSL.swift
//  UIUTestExampleTests
//
//  Created by thompsty on 9/28/20.
//  Copyright © 2020 Purgatory Design. All rights reserved.
//

import Foundation
import CucumberSwift
import UIUTest
import XCTest
import UIUTestExample

extension Cucumber {
    class AuthenticationDSLSteps {
        var viewController: AuthenticationViewController!
        var userNameField: UITextField!
        var passwordField: UITextField!
        var showPasswordButton: UIButton!
        var authenticateButton: UIButton!
        var invalidCredentialsLabel: UILabel!
        func setup() {
            Feature("Authentication") { () -> [ScenarioDSL] in
                Scenario("I want to know when I can sign in") { [self] in
                    Given(I: amNotLoggedIn())
                    When(I: enterAValidUsername())
                        And(I: enterAValidPassword())
                    Then(I: canSignIn())
                }
                Scenario("I want to know if I can't sign in") { [self] in
                    Given(I: amNotLoggedIn())
                    When(I: haveNotEnteredAValidUsername())
                        And(I: haveNotEnteredAValidPassword())
                    Then(I: cannotSignIn())
                }
                Scenario("I want to see my password") { [self] in
                    Given(I: amNotLoggedIn())
                    When(I: enterAValidPassword())
                        And(I: wantToSeeWhatITyped())
                    Then(my: passwordIsNotObscured())
                }
                Scenario("I log in successfully") { [self] in
                    Given(I: amNotLoggedIn())
                    When(I: enterValidCredentials())
                        And(I: signIn())
                    Then(I: seeTheNextScreen())
                }
                Scenario("I enter the wrong credentials") { [self] in
                    Given(I: amNotLoggedIn())
                    When(I: enterAValidUsername())
                    But(I: haveNotEnteredAValidPassword())
                    Then(I: amNotLoggedIn())
                }
            }
        }
        
        private func amNotLoggedIn() {
            viewController = (UIViewController.loadFromStoryboard(identifier: "Authentication") as! AuthenticationViewController)
            let view = viewController.view!
            userNameField = (view.viewWithAccessibilityIdentifier("userName") as! UITextField)
            passwordField = (view.viewWithAccessibilityIdentifier("password") as! UITextField)
            showPasswordButton = (view.viewWithAccessibilityIdentifier("showPassword") as! UIButton)
            authenticateButton = (view.viewWithAccessibilityIdentifier("authenticate") as! UIButton)
            invalidCredentialsLabel = (view.viewWithAccessibilityIdentifier("invalidCredentials") as! UILabel)
            XCTAssertFalse(authenticateButton.isEnabled)
        }
        
        private func enterValidCredentials() {
            viewController.setAuthenticator(TestAuthenticator())
            userNameField.text = TestAuthenticator.validUser
            passwordField.setTextAndNotify(TestAuthenticator.validPassword)
        }
        
        private func enterAValidUsername() {
            userNameField.simulateTouch()
            userNameField.simulateTyping("Test User")
        }
        
        private func haveNotEnteredAValidUsername() {
            userNameField.simulateTouch()
            userNameField.simulateTyping(nil)
        }
        
        private func haveNotEnteredAValidPassword() {
            passwordField.setTextAndNotify(TestAuthenticator.invalidPassword)
        }
        
        private func enterAValidPassword() {
            passwordField.simulateTouch()
            passwordField.simulateTyping("Test Password")
        }
        
        private func canSignIn() {
            XCTAssertTrue(authenticateButton.isEnabled)
        }
        
        private func cannotSignIn() {
            XCTAssertFalse(authenticateButton.isEnabled)
        }
        
        private func wantToSeeWhatITyped() {
            XCTAssertTrue(viewController.passwordIsSecure)
            XCTAssertTrue(passwordField.isSecureTextEntry)
            XCTAssertEqual(showPasswordButton.currentTitle!, "SHOW")
            showPasswordButton.simulateTouch()
        }
        
        private func passwordIsNotObscured() {
            XCTAssertFalse(viewController.passwordIsSecure)
            XCTAssertFalse(passwordField.isSecureTextEntry)
            XCTAssertEqual(showPasswordButton.currentTitle!, "HIDE")
        }
        
        private func seeTheNextScreen() {
            XCTAssertTrue(viewController.hasBeenDismissed)
        }
        
        private func signIn() {
            authenticateButton.simulateTouch()
        }
    }
}
