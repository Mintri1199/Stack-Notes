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
  var selectedColor: UIColor? = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) {
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
    self.view.backgroundColor = selectedColor
    setupTodoView()
    setupColorStackView()
    changingColor()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configNavBar()
  }
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    appearingViews()
    colorStackView.arrangedSubviews.forEach { (button) in
      guard let button = button as? ColorButton else { return }
      if button.circleLayer.fillColor != selectedColor!.cgColor {
        button.borderLayer.lineWidth = 0
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
//    colorStackView.pinkButton.borderLayer.lineWidth = 10
//    colorStackView.pinkButton.circleLayer.lineWidth = 0
//    colorStackView.arrangedSubviews.forEach { (button) in
//      if let button = button as? UIButton {
//        button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
//      }
//    }
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
                              color: selectedColor!)
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

extension AddTodoViewController {
  // MARK: Background Color Changing Animation
  func changingColor() {
    // The faux layers
    let navBarLayer = CALayer()
    //    let viewLayer = CALayer()
    //    viewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
    var bounds = navigationController?.navigationBar.bounds
    bounds?.size.height += UIApplication.shared.statusBarFrame.height
    
    navBarLayer.backgroundColor = UIColor.red.cgColor
    navBarLayer.frame = bounds!
    //    navigationController?.navigationBar.layer.addSublayer(navBarLayer)
    //    navigationController?.navigationBar.layer.addSublayer(navBarLayer)
    //    navigationController?.navigationBar.layer.insertSublayer(navBarLayer, at: 1)
    
    //    self.view.layer.addSublayer(viewLayer)
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
          }, completion: nil)
        }
      })
    }
  }
}
