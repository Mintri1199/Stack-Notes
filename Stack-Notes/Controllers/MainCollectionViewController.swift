//
//  MainCollectionViewController.swift
//  Stack-Notes
//
//  Created by Jackson Ho on 6/10/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {

    var viewModel: [Int] = [1,2,3,4,5]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        setupSelfView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavBar()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.count == 0 {
            setupEmptyView()
        } else {
            self.collectionView.restore()
        }
        
        return viewModel.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

// MARK: UI Functions
extension MainCollectionViewController {
    private func setupEmptyView() {
        let emptyView = EmptyView(frame: self.view.bounds)
        self.collectionView.backgroundView = emptyView
    }
    
    private func setupSelfView() {
        collectionView.backgroundColor = .mainBackgroundGray
    }
    
    private func configNavBar() {
        self.title = "Todos"
        // Color of the nav bar
        navigationController?.navigationBar.barTintColor = .mainNavBarBlack
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Nav bar buttons
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        navigationItem.leftBarButtonItem = deleteButton
    }
}


// MARK: Objc functions
extension MainCollectionViewController {
    
    @objc private func addButtonTapped() {
        navigationController?.pushViewController(AddTodoViewController(), animated: true)
    }
    
    @objc private func trashTapped() {
        print("Trash button tapped")
    }
}
