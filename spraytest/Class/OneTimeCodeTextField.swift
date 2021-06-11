//
//  OneTimeCodeTextField.swift
//  spraytest
//
//  Created by Dominic O. Ighedosa on 5/27/21.
//  Copyright © 2021 Ighedosa, Dominic. All rights reserved.
//

import UIKit
class OneTimeCodeTextField: UITextField {
    
    //this is a closure
    var didEnterLastDigit: ((String) -> Void)?
    
    var defaultCharacter = "_"
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    func configure(with slotCount: Int = 6) {
        guard isConfigured == false else {return}
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackview = createLabelsStackView(with: slotCount)
        addSubview(labelsStackview)
        
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([labelsStackview.topAnchor.constraint(equalTo: topAnchor),
             labelsStackview.leadingAnchor.constraint(equalTo: leadingAnchor),
             labelsStackview.trailingAnchor.constraint(equalTo: trailingAnchor),
             labelsStackview.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType  = .oneTimeCode
        
        borderStyle = .none
        layer.borderWidth = 0.0
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.backgroundColor = .white
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        return stackView
    }
    
    @objc
    private func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else {return}
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                //currentLabel.text?.removeAll()
                currentLabel.text = defaultCharacter
                
            }
        }
        
        //if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        //}
    }
}

extension OneTimeCodeTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else {return false}
        
        return characterCount < digitLabels.count || string == ""
    }
}