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
    self.view.backgroundColor = selectedColor
    selectedColor = todo!.color
    setupTodoView()
    setupColorStackView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configNavBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    appearingViews()
    colorStackView.arrangedSubviews.forEach { (button) in
      guard let button = button as? ColorButton else { return }
      let color = selectedColor.cgColor
      let buttonColor = button.circleLayer.fillColor!
      if buttonColor.compareConvertingColorSpace(other: color) {
        let expand = CABasicAnimation(keyPath: "lineWidth")
        expand.toValue = 4
        expand.duration = 0.5
        expand.fillMode = .forwards
        expand.setValue(button.borderLayer, forKey: "layer")
        expand.setValue("expand", forKey: "name")
        expand.delegate = self
        button.borderLayer.add(expand, forKey: nil)
      } else {
        let shrink = CABasicAnimation(keyPath: "lineWidth")
        shrink.toValue = 0
        shrink.duration = 0.5
        shrink.fillMode = .forwards
        shrink.setValue(button.borderLayer, forKey: "layer")
        shrink.setValue("shrink", forKey: "name")
        shrink.delegate = self
        button.borderLayer.add(shrink, forKey: nil)
      }
    }
  }
}

// MARK: UI Functions
extension TodoDetailViewController {
  private func setupTodoView() {
    self.view.addSubview(todoView)
    NSLayoutConstraint.activate([
      todoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      todoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
      todoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -25 ),
      todoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.50),
      todoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height)
      ])
    todoView.descriptionTextView.delegate = self
    todoView.titleTextField.delegate = self
  }
  
  private func setupColorStackView() {
    self.view.addSubview(colorStackView)
    NSLayoutConstraint.activate([
      colorStackView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
      colorStackView.leadingAnchor.constraint(equalTo: todoView.leadingAnchor),
      colorStackView.trailingAnchor.constraint(equalTo: todoView.trailingAnchor)
      ])
    // 50 is the sum of the  left and right anchor constants
    let buttonHeight = (UIScreen.main.bounds.width - (80 + 50)) / 5
    colorStackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    colorStackView.pinkButton.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
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
                                           color: selectedColor,
                                           small: false))
      navigationController?.popViewController(animated: true)
    }
  }
  @objc func colorSelected(_ sender: ColorButton) {
    print("tapped")
    colorStackView.arrangedSubviews.forEach { (button) in
      guard let button = button as? ColorButton else { return }
      let color = sender.circleLayer.fillColor!
      let buttonColor = button.circleLayer.fillColor!
      // Add shrink animation to the other of buttons that does match the
      // selected color
      if !buttonColor.compareConvertingColorSpace(other: color) {
        let shrink = CABasicAnimation(keyPath: "lineWidth")
        shrink.toValue = 0
        shrink.duration = 0.5
        shrink.fillMode = .forwards
        shrink.setValue(button.borderLayer, forKey: "layer")
        shrink.setValue("shrink", forKey: "name")
        shrink.delegate = self
        button.borderLayer.add(shrink, forKey: nil)
      }
    }
    // Add the border expand animation to the tapped button
    if let color = sender.circleLayer.fillColor {
      let expand = CABasicAnimation(keyPath: "lineWidth")
      expand.toValue = 4
      expand.duration = 0.5
      expand.fillMode = .forwards
      expand.setValue(sender.borderLayer, forKey: "layer")
      expand.setValue("expand", forKey: "name")
      expand.delegate = self
      sender.borderLayer.add(expand, forKey: nil)
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
// MARK: Animations
extension TodoDetailViewController {
  func appearingViews() {
    todoView.superview!.constraints.forEach { (constraint) in
      if constraint.firstAttribute == .centerY {
        // Get rid of the constraint
        constraint.isActive = false
        // Create new constraint
        let newContraint = NSLayoutConstraint(
          item: todoView,
          attribute: .top,
          relatedBy: .equal,
          toItem: self.view, attribute: .topMargin,
          multiplier: 1,
          constant: 15)
        newContraint.isActive = true
        return
      }
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
        self.view.layoutIfNeeded()
      }, completion: { _ in
        self.colorStackView.superview!.constraints.forEach { (constraint) in
          if constraint.firstItem === self.colorStackView && constraint.firstAttribute == .top {
            // Get rid of the constraint
            constraint.isActive = false
            // Create new constraint
            let newContraint = NSLayoutConstraint(
              item: self.colorStackView,
              attribute: .top,
              relatedBy: .equal,
              toItem: self.todoView, attribute: .bottom,
              multiplier: 1,
              constant: 15)
            newContraint.isActive = true
            return
          }
          // Animate the buttons coming in after the todo view finish animating
          UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
          }, completion: nil)
        }
      })
    }
  }
}
extension TodoDetailViewController: CAAnimationDelegate {
  func animationDidStart(_ anim: CAAnimation) {
    if let name = anim.value(forKey: "name") as? String {
      if name == "expand", let layer = anim.value(forKey: "layer") as? CAShapeLayer {
        layer.lineWidth = 4
      } else if name == "shrink", let layer = anim.value(forKey: "layer") as? CAShapeLayer {
        layer.lineWidth = 0
      }
    }
  }
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    //
  }
}
