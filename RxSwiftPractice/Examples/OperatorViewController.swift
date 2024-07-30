//
//  OperatorViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class OperatorViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        // just, from, of
        // zip, combinelateset
        Observable
            .repeatElement("Jack")
            .take(10)               // 이게 없으면 무한방출..
            .subscribe { value in
                print("next: \(value)")
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)

    }
    
}
