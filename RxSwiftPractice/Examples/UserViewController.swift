//
//  UserViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserViewController: UIViewController {
    
    let nicknameTextField = UITextField()
    let checkButton = UIButton()
    let disposeBag = DisposeBag()
    
//    let sampleNicknameNormal = "고래밥"
    
    // Observable.just("고래밥") >> 전달만 가능. 이벤트.데이터 못받음.
    // >> Observable 과 Observer를 동시에 할 수 있는 Subject
    // var sampleNickname
//    let sampleNicknameRx = Observable.just("고래밥")
    
    let sampleNicknameRx = BehaviorSubject(value: "고래밥")
    let behavior = BehaviorSubject(value: 100) // 초기값 있음. -> 가장 마지막에 전달받은거 가지고옴
    let publish = PublishSubject<Int>() // 초기값 없음.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        nicknameTest()
//        testBehaviorSubject()
        testPublishSubject()
    }
    
    func nicknameTest() {
        // 기존의 간단한 방식
//        nicknameTextField.text = sampleNicknameNormal
        sampleNicknameRx
            .bind(with: self) { owner, value in
                // = 로 값을 바꾸지 않습니다...
                // 값을 바꾸든 뭐든 다 '이벤트를 전달' 하는 행위
                // next complete error
                
                owner.nicknameTextField.text = value
            }
            .disposed(by: disposeBag)
        
        sampleNicknameRx
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        checkButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.nicknameTextField.text = "칙촉"
                owner.sampleNicknameRx.onNext("칙촉")
            }
            .disposed(by: disposeBag)
    }
    
    func testBehaviorSubject() {
        
        // 구독하기 전이라 안나옴..
        behavior.onNext(1)
        behavior.onNext(2)
        
        // 근데 넌 왜나와??
        behavior.onNext(3)
        
        behavior
            .subscribe { value in
                print("behavior text = \(value)")
            } onError: { error in
                print("behavior error")
            } onCompleted: {
                print("behavior onCompleted")
            } onDisposed: {
                print("behavior onDisposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(4)
        behavior.onNext(5)
        behavior.onNext(6)
    }
    
    func testPublishSubject() {
        publish.onNext(1)
        publish.onNext(2)
        
        // behavior 와는 다르게 안뜨는 모습
        publish.onNext(3)
        
        publish
            .subscribe { value in
                print("behavior text = \(value)")
            } onError: { error in
                print("behavior error")
            } onCompleted: {
                print("behavior onCompleted")
            } onDisposed: {
                print("behavior onDisposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(4)
        publish.onNext(5)
        publish.onNext(6)
    }
    
    func configureView() {
        view.addSubview(nicknameTextField)
        view.addSubview(checkButton)
        nicknameTextField.backgroundColor = .systemRed
        checkButton.backgroundColor = .green
        nicknameTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        checkButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
    }
}
