//
//  ViewController.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit
import CoreGraphics

// MARK: Add todo delegate
protocol AddTodo: class {
  func addTodo(todo: Todo)
}

class AddTodoViewController: UIViewController {
  // MARK: Variables
  var selectedColor: UIColor? = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) {
    didSet {
     changeColor()
    }
  }
  weak var delegate: AddTodo?
  
  // MARK: Custom UIs
  var todoView = TodoView()
  var colorStackView = ColorOptionsStackView()
  var smallTaskButton = SmallTodoIndicator()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = selectedColor
    setupTodoView()
    setupColorStackView()
    setupSmallTodoButton()
    
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
      let color = selectedColor!.cgColor
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
extension AddTodoViewController {
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
    navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    // Nav bar buttons
    let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    navigationItem.rightBarButtonItem = addButton
  }
  
  private func setupSmallTodoButton() {
    self.view.addSubview(smallTaskButton)
    NSLayoutConstraint.activate([
      smallTaskButton.topAnchor.constraint(equalTo: colorStackView.bottomAnchor, constant: 100),
      smallTaskButton.leadingAnchor.constraint(equalTo: colorStackView.leadingAnchor, constant: 10),
      smallTaskButton.trailingAnchor.constraint(equalTo: colorStackView.trailingAnchor, constant: -10),
      smallTaskButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06)
      ])
    smallTaskButton.nameLabel.textColor = selectedColor!
  }
  
  private func changeColor() {
    self.view.backgroundColor = selectedColor
    navigationController?.navigationBar.barTintColor = selectedColor
    smallTaskButton.nameLabel.textColor = selectedColor
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
                              color: selectedColor!)
      delegate?.addTodo(todo: newTodo)
      navigationController?.popViewController(animated: true)
    }
  }
  @objc func colorSelected(_ sender: ColorButton) {
    colorStackView.arrangedSubviews.forEach { (button) in
      guard let button = button as? ColorButton else { return }
      let color = sender.circleLayer.fillColor!
      let buttonColor = button.circleLayer.fillColor!
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

// MARK: CoreAnimationDelegate
extension AddTodoViewController: CAAnimationDelegate {
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
// MARK: Animations
extension AddTodoViewController {
  
  // MARK: Background Color Changing Animation
  // TODO: Come back to this later
  func changingColor() {
    // The faux layers
    let navBarLayer = CALayer()
    var bounds = navigationController?.navigationBar.bounds
    bounds?.size.height += UIApplication.shared.statusBarFrame.height
    
    navBarLayer.backgroundColor = UIColor.red.cgColor
    navBarLayer.frame = bounds!
  }
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
          }, completion: { _ in
            self.smallTaskButton.superview?.constraints.forEach({ (constraint) in
              if constraint.firstItem === self.smallTaskButton && constraint.firstAttribute == .top {
                // Get rid of the constraint
                constraint.constant = 20
                return
              }
            })
            // Animate the button coming in after
              UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
              }, completion: nil)
             
          })
        }
      })
    }
  }
}

extension CGColor {
  func compareConvertingColorSpace(other: CGColor) -> Bool {
    let approximateColor = other.converted(to: self.colorSpace!, intent: .defaultIntent, options: nil) // fatal errror with no color space
    return self == approximateColor
  }
}
