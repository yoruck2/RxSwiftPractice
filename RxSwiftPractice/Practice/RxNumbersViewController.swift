//
//  RxNumbersViewController.swift
//  RxSwiftPractice
//
//  Created by dopamint on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class RxNumbersViewController: RxBaseViewController {
    
    let operatorLabel = UILabel()
    let divider = UIView().then {
        $0.backgroundColor = .gray
    }
    
    var number1 = OperandField()
    var number2 = OperandField()
    var number3 = OperandField()
    
    var result = UILabel().then {
        $0.textAlignment = .right
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        
        view.addSubview(operatorLabel)
        view.addSubview(divider)
        
        view.addSubview(result)
    }
    
    override func configureLayout() {
        number1.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(200)
        }
        number2.snp.makeConstraints { make in
            make.centerX.equalTo(number1)
            make.top.equalTo(number1.snp.bottom).offset(5)
        }
        number3.snp.makeConstraints { make in
            make.centerX.equalTo(number1)
            make.top.equalTo(number2.snp.bottom).offset(5)
        }
        operatorLabel.snp.makeConstraints { make in
            make.trailing.equalTo(number3.snp.leading).offset(30)
        }
        divider.snp.makeConstraints { make in
            make.centerX.equalTo(number1)
            make.top.equalTo(number3.snp.bottom).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(1)
        }
        result.snp.makeConstraints { make in
            make.centerX.equalTo(number1)
            make.top.equalTo(divider.snp.bottom).offset(5)
            make.trailing.equalTo(number3)
        }
        
    }
}

class OperandField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 2
        layer.borderColor = UIColor(named: "lightGray")?.cgColor
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .right
        
        self.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
