//
//  ViewControllerRobot.swift
//  PracticeAppUITests
//
//  Created by Danny Tsang on 3/5/22.
//

import XCTest

class MainViewControllerRobot {

    func tapFollowButton() -> MainViewControllerRobot {
        let followButton = XCUIApplication().buttons["ViewController.FollowButton"]
        followButton.tap()
        return self
    }
    
    func tapZoomInButton() -> MainViewControllerRobot {
        let zoomInButton = XCUIApplication().buttons["ViewController.ZoomInButton"]
        zoomInButton.tap()
        return self
    }

    func tapZoomOutButton() -> MainViewControllerRobot {
        let zoomOutButton = XCUIApplication().buttons["ViewController.ZoomOutButton"]
        zoomOutButton.tap()
        return self
    }
    
    func tapSearchButton() -> LookUpAddressRobot {
        let searchButton = XCUIApplication().buttons["ViewController.SearchButton"]
        searchButton.tap()
        
        return LookUpAddressRobot()
    }
    
    func verifyOnMainView() -> MainViewControllerRobot {
        let navBar = XCUIApplication().navigationBars["Main View"]
        XCTAssert(navBar.exists)
        return self
    }
    
    func verifyFollowMode(is mode: Bool) -> MainViewControllerRobot {
        let followButton = XCUIApplication().buttons["ViewController.FollowButton"]
        
        if mode == true {
            XCTAssert(followButton.label == "Follow On")
        } else {
            XCTAssert(followButton.label == "Follow Off")
        }
        return self
    }
}
