//
//  BasicButtonViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class BasicButtonViewController: UIViewController {
    let button = UIButton()
    let label = UILabel()
    
    let textField = UITextField()
    let secondLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        firstExample()
        secondExample()
    }
    // TODO: observable, observer, subscribe, bind
    // TODO: 흐름 따라가보면서 복습
    // TODO: pickerView, tableView, UISwitch, UITextFiled, UIButton
    // TODO: just, of, from, take
    // TODO: rx example
    
    private func firstExample() {
        //        button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        
        button // UIButton
            .rx // reactive<>
            .tap.subscribe { _ in
                self.label.text = "버튼을 클릭했어요"
            } onError: { _ in
                print("error")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }.disposed(by: disposeBag)
        
        // 2. 에러 발생할 일이 없을 때 (infinite)
        button.rx.tap
            .subscribe { _ in
                self.label.text = "버튼을 클릭했어요"
            } onDisposed: {
                print("disposed")
            }.disposed(by: disposeBag)
        
        // 3. self 캡처 때문에 메모리 누수 가능성 을 약한참조로
        button.rx.tap
            .subscribe { [weak self] _ in
            self?.label.text = "버튼을 클릭해어요"
            } onDisposed: {
                print("disposed")
            }.disposed(by: disposeBag)
        
        // 4.
        button.rx.tap
            .subscribe { _ in
                self.label.text = "버튼을 클릭했어요"
            } onDisposed: {
                print("disposed")
            }.disposed(by: disposeBag)
        
        
        // 5. withUnretained 로 약한 참조로 self 캡처 가능 (weak self 생략 가능)
        button.rx.tap
            .withUnretained(self)  // weak self
            .subscribe { _ in
                self.label.text = "버튼을 클릭해어요"
            }
            .disposed(by: disposeBag)
        
        // 6. 그럼 뭐해.. withUnretained 계속 써줘야 되는데 에서 주로쓰는 방식
        button.rx.tap
            .subscribe(with: self) { owner, _ in
            owner.label.text = "버튼을 클릭했어요"
        } onDisposed: { owner in
            print("disposed")
        }
        .disposed(by: disposeBag)
        
        //
        button.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                DispatchQueue.main.async {
                    owner.label.text = "버튼을 클릭했어요"
                }
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        // 7. .observe 로 메인쓰레드에서 동작 하도록 하기
        button.rx.tap
            .observe(on: MainScheduler.instance) // 메인 쓰레드
            .subscribe(with: self, onNext: { owner, _ in
                owner.label.text = "버튼을 클릭했어요"
            }, onDisposed: { owner in
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        // 8. 이것도 귀찮다!!
        // 메인쓰레드로 동작시켜주는 친구는 왜 안만들어주냐 + 애초에 error 안받는 친구는 없음?
        button.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.label.text = "버튼을 클릭했어요"
            })
            .disposed(by: disposeBag)
        
        // 9.
        button.rx.tap
            .map { "버튼을 클릭했어요" } // Observabel<String>
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 퀴즈: button.tx.tap 은 subscribe 되면서, label.rx.text 는 왜 안됨??
    }
    func secondExample() {
        button.rx.tap
            .map { "버튼을 다시 클릭했어요" }
            .map { "\($0)" }
            .bind(to: secondLabel.rx.text, textField.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    func configureView() {
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(secondLabel)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(100)
        } 
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.width.equalTo(50)
            make.top.equalTo(label.snp.bottom).offset(20)
        }
        secondLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        button.backgroundColor = .green
        textField.backgroundColor = .magenta
        secondLabel.backgroundColor = .lightGray
    }
}
