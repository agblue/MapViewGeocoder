//
//  ViewControllerRobot.swift
//  PracticeAppUITests
//
//  Created by Danny Tsang on 3/5/22.
//

import XCTest

class ViewControllerRobot {

    func tapFollowButton() -> ViewControllerRobot {
        let followButton = XCUIApplication().buttons["ViewController.FollowButton"]
        followButton.tap()
        return self
    }
    
    func tapZoomInButton() -> ViewControllerRobot {
        let zoomInButton = XCUIApplication().buttons["ViewController.ZoomInButton"]
        zoomInButton.tap()
        return self
    }

    func tapZoomOutButton() -> ViewControllerRobot {
        let zoomOutButton = XCUIApplication().buttons["ViewController.ZoomOutButton"]
        zoomOutButton.tap()
        return self
    }
    
    func tapSearchButton() -> LookUpAddressRobot {
        let searchButton = XCUIApplication().buttons["ViewController.SearchButton"]
        searchButton.tap()
        
        return LookUpAddressRobot()
    }
    
    func verifyOnMainView() -> ViewControllerRobot {
        let navBar = XCUIApplication().navigationBars["Main View"]
        XCTAssert(navBar.exists)
        return self
    }
    
    func verifyFollowMode(is mode: Bool) -> ViewControllerRobot {
        let followButton = XCUIApplication().buttons["ViewController.FollowButton"]
        
        if mode == true {
            XCTAssert(followButton.label == "Follow On")
        } else {
            XCTAssert(followButton.label == "Follow Off")
        }
        return self
    }
}
