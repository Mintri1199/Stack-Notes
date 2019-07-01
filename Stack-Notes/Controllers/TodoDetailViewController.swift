//
//  TodoDetailViewController.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/30/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit
import CoreData

class TodoDetailViewController: UIViewController {
  // MARK: Variables
  var todoId: NSManagedObjectID?
  var todo: Todo?
  var selectedColor: UIColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) {
    didSet {
      self.view.backgroundColor = selectedColor
      navigationController?.navigationBar.barTintColor = selectedColor
    }
  }
  var todoStore: TodoStore!
  // MARK: Custom UIs
  var todoView = TodoView()
  var colorStackView = ColorOptionsStackView()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    selectedColor = todo!.color
    setupSelfView()
    setupTodoView()
    setupColorStackView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configNavBar()
  }
}

// MARK: UI Functions
extension TodoDetailViewController {
  private func setupSelfView() {
    self.view.backgroundColor = selectedColor
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
    // Placing the text
    if let descriptionText = todo?.description {
      todoView.descriptionTextView.text = descriptionText
    }
    if let titleText = todo?.title {
      todoView.titleTextField.text = titleText
    }
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
    colorStackView.heightAnchor.constraint(equalToConstant:
      buttonHeight).isActive = true
    colorStackView.pinkButton.circleLayer.lineWidth = 4
    colorStackView.pinkButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
    colorStackView.blueButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
    colorStackView.greenButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
    colorStackView.yellowButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
    colorStackView.purpleButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
  }
  private func configNavBar() {
    self.title = "Add Todo"
    // Color of the nav bar
    navigationController?.navigationBar.barTintColor = selectedColor
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    // Nav bar buttons
    let updateButton = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(updateButtonTapped))
    navigationItem.rightBarButtonItem = updateButton
  }
}

// MARK: OBJC functions
extension TodoDetailViewController {
  @objc private func updateButtonTapped() {
    if checkTitle() {
      // Add animation
    } else {
      // Update Todo
      todoStore.updateTodo(entityId: todoId!,
                           todo: Todo.init(title: todoView.titleTextField.text!,
                                           description: todoView.descriptionTextView.text,
                                           done: false,
                                           color: selectedColor))
      navigationController?.popViewController(animated: true)
    }
  }
  @objc func colorSelected(_ sender: ColorButton) {
    print("tapped")
    colorStackView.arrangedSubviews.forEach { (button) in
      guard let button = button as? ColorButton else { return }
      if sender.circleLayer.fillColor != button.circleLayer.fillColor! {
        button.borderLayer.lineWidth = 0
      }
    }
    if let color = sender.circleLayer.fillColor {
      selectedColor = UIColor(cgColor: color)
    }
  }
}

// MARK: TextViewDelegate
extension TodoDetailViewController: UITextViewDelegate {
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
extension TodoDetailViewController: UITextFieldDelegate {
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
