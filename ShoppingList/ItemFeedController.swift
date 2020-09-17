//
//  ItemFeedController.swift
//  ShoppingList
//
//  Created by Tiffany Obi on 7/15/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit


class ItemFeedController: UIViewController {
    
    private var tableView:UITableView!
    private var dataSource:DataSource! // is this subclass we created
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureDataSource()
    }
    
   
    
    private func configureNavBar(){
        navigationItem.title = "Shopping List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditState))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(presentAddVC))
    }
    
    private func configureTableView(){
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView.backgroundColor = .systemTeal
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        view.addSubview(tableView)
    }
    private func configureDataSource(){
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
            let formattedPrice = String(format: "%.2f", item.price)
            cell.textLabel?.text = "\(item.name)\nPrice: $\(formattedPrice)"
            cell.textLabel?.numberOfLines = 0
            return cell
        })
        
        //set up type of animation
        dataSource.defaultRowAnimation = .middle
        
        //setUp initial snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Category,Item>()
        
        //populate the snapshot with sections and items in each section
        //CaseIterable allows us to interate thru an enum like an array
        
        for catergory in Category.allCases {
            //filter the test data items for that particular category's items
            
            let items = Item.testData().filter{$0.category == catergory}
            snapshot.appendSections([catergory])
            snapshot.appendItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    @objc private func toggleEditState(){
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @objc private func presentAddVC(){
        
        //#1 create instance of addVcController
        guard let addItemVC = storyboard?.instantiateViewController(identifier: "AddItemController") as? AddItemController else {return
            
        }
        //#2 make addItemVC = self
        addItemVC.addItemDelegate = self
        
        present(addItemVC, animated: true)
    }
}
extension ItemFeedController: AddItemVCDelegate{
    func didAddItem(item: Item, addItemVC: AddItemController) {
        var snapshot = dataSource.snapshot()
        
        snapshot.appendItems([item], toSection: item.category)
        
        dataSource.apply(snapshot,animatingDifferences: true)
        
        
    }
    
}
