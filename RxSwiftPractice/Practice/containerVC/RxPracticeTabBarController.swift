//
//  PracticeTabBarController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit

final class RxPracticeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playgroundVC = PracticeNavigationController(
            rootViewController: PlaygroundViewController())
        
        let tableVC = PracticeNavigationController(
            rootViewController: RxTableViewController())
        
        let validtionVC = PracticeNavigationController(
            rootViewController: RxValidationViewController())
        
        let numbersVC = PracticeNavigationController(
            rootViewController: RxNumbersViewController())
        
        let pickerVC = PracticeNavigationController(
            rootViewController: RxPickerViewController())
        
        setViewControllers([playgroundVC, tableVC, validtionVC, numbersVC, pickerVC], animated: true)
        
        if let items = tabBar.items {
            items[0].image = UIImage(systemName: "logo.playstation")
            items[1].image = UIImage(systemName: "list.bullet")
            items[2].image = UIImage(systemName: "checkmark.square.fill")
            items[3].image = UIImage(systemName: "number")
            items[4].image = UIImage(systemName: "arrow.turn.up.forward.iphone")
        }
    }
}
