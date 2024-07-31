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

/*
 1) .disposed(by
 */
class OperatorViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    deinit {
        print("OpeatorViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        // just, from, of
        // zip, combinelateset
//        Observable
//            .repeatElement("Jack")
//            .take(10)               // 이게 없으면 무한방출..
//            .subscribe { value in
//                print("next: \(value)")
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")
//            }
//            .disposed(by: disposeBag)
//        
        testJustObservable()
        testOfObservable()
        testFromObservable()
//        testIntervalObservable()
        testIntervalObservable2()
    }
    
    let list = [1,2,3,4,5,6,7,8,9,10]
    
    func testJustObservable() {
        Observable
            .just(list)
            .subscribe { value in
                print("next = \(value)")
            } onError: { error in
                print("error = \(error)")
            } onCompleted: {
                print("com")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
    }
    func testOfObservable() {
        Observable
            .of(list)
            .subscribe { value in
                print("next = \(value)")
            } onError: { error in
                print("error = \(error)")
            } onCompleted: {
                print("com")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
    }
    func testFromObservable() {
        Observable
            .from(list)
            .subscribe { value in
                print("next = \(value)")
            } onError: { error in
                print("error = \(error)")
            } onCompleted: {
                print("com")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func testIntervalObservable() {
        
        let incrementValue = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let observer = incrementValue
            .subscribe { value in
                print("next = \(value)")
            } onError: { error in
                print("error = \(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            observer.dispose()
        }
    }    
    func testIntervalObservable2() {
        
        let incrementValue = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
        
        let observer = incrementValue
            .subscribe { value in
                print("next = \(value)")
            } onError: { error in
                print("error = \(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.disposeBag = DisposeBag()
        }
    }
    
    
}
