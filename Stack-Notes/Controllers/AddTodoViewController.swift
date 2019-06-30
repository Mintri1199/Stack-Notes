//
//  ViewController.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

// MARK: Add todo delegate
protocol AddTodo: class {
    func addTodo(todo: Todo)
}

class AddTodoViewController: UIViewController {
    // MARK: Variables
    var selectedColor: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) {
        didSet {
            self.view.backgroundColor = selectedColor
            navigationController?.navigationBar.barTintColor = selectedColor
        }
    }
    weak var delegate: AddTodo?
    // MARK: Custom UIs
    var todoView = TodoView()
    var colorStackView = ColorOptionsStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupSelfView()
        setupTodoView()
        setupColorStackView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavBar()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: UI Functions
extension AddTodoViewController {
    private func setupSelfView() {
        self.view.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }
    private func setupTodoView() {
        self.view.addSubview(todoView)
        NSLayoutConstraint.activate([
            todoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            todoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            todoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -25 ),
            todoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            todoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.50)
            ])
        todoView.descriptionTextView.delegate = self
        todoView.titleTextField.delegate = self
    }
    private func setupColorStackView() {
        self.view.addSubview(colorStackView)
        NSLayoutConstraint.activate([
            colorStackView.topAnchor.constraint(equalTo: todoView.bottomAnchor, constant: 30),
            colorStackView.leadingAnchor.constraint(equalTo: todoView.leadingAnchor),
            colorStackView.trailingAnchor.constraint(equalTo: todoView.trailingAnchor)
            ])
        // 50 is the sum of the  left and right anchor constants
        let buttonHeight = (UIScreen.main.bounds.width - (80 + 50)) / 5
        colorStackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        colorStackView.pinkButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        colorStackView.blueButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        colorStackView.greenButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        colorStackView.yellowButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
        colorStackView.purpleButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
    }

    private func configNavBar() {
        self.title = "Add Todo"
        // Color of the nav bar
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        // Nav bar buttons
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
}

// MARK: OBJC functions
extension AddTodoViewController {
    @objc private func saveButtonTapped() {
        if checkTitle() {
            // Add animation
        } else {
            let title = todoView.titleTextField.text!
            let description = todoView.descriptionTextView.text
            let newTodo = Todo.init(title: title,
                                   description: description,
                                   done: false,
                                   color: selectedColor)
            delegate?.addTodo(todo: newTodo)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: TextViewDelegate
extension AddTodoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

// MARK: TextFieldDelegate
extension AddTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Stop the user from editing when the keyboard is hidden
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        todoView.titleTextField.endEditing(true)
    }
    // Input validation
    private func checkTitle() -> Bool {
        if let text = todoView.titleTextField.text {
            let trimmingString = text.trimmingCharacters(in: .whitespaces)
            if trimmingString.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }
}

// MARK: Color Button Animation
extension AddTodoViewController {
    @objc func colorSelected(_ sender: ColorButton) {
        print("tapped")
        if let color = sender.circleLayer.fillColor {
            selectedColor = UIColor(cgColor: color)
        }
//        if selectedColorButton != sender.tag && sender.borderLayer.lineWidth == 0 {
//            selectedColorButton = sender.tag
//            // Create lineWidth Expand animation
//            let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
//            lineWidthAnimation.setValue("expand", forKey: "name")
//            lineWidthAnimation.setValue(sender.borderLayer, forKey: "layer")
//            lineWidthAnimation.toValue = 5
//            lineWidthAnimation.duration = 0.25
//            lineWidthAnimation.fillMode = .both
//            lineWidthAnimation.delegate = self
//            sender.borderLayer.add(lineWidthAnimation, forKey: nil)
//            sender.isSelected = true
//        } else {
//            print("button \(sender.tag) is the selected button \(selectedColorButton)")
//        }
    }
    // Shrinking animation
    private func shrinkButton(sender: ColorButton) {
        let shrinkBorder = CABasicAnimation(keyPath: "lineWidth")
        shrinkBorder.setValue("shrink", forKey: "name")
        shrinkBorder.setValue(sender.borderLayer, forKey: "layer")
        shrinkBorder.toValue = 0
        shrinkBorder.duration = 0.5
        shrinkBorder.delegate = self
        shrinkBorder.fillMode = .both
        sender.borderLayer.add(shrinkBorder, forKey: nil)
        sender.isSelected = false
    }

}

// MARK: CoreAnimationDelegate
extension AddTodoViewController: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        //
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //
    }
}
