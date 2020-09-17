//
//  DataSource.swift
//  ShoppingList
//
//  Created by Tiffany Obi on 7/15/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

//conforms to UITableViewDataSource
class DataSource: UITableViewDiffableDataSource<Category,Item>{
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Category.allCases[section] == .shoppingCart {
            return "🛒" + Category.allCases[section].rawValue
        } else {

        return Category.allCases[section].rawValue
    }
    
}
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //get current snapshot
            var snapshot = self.snapshot()
            
            //get item using  itemIdentifier
            if let item = itemIdentifier(for: indexPath){
                snapshot.deleteItems([item])
            
                //apply snapshot(apply changes to the dataSource)
                apply(snapshot,animatingDifferences: true)
        }
    }
}
    //1.reordering steps
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //. reordering steps
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //get source item
        
        guard let sourceItem = itemIdentifier(for: sourceIndexPath) else {return}
        
        //scenrio:1-attempting to move to self
        guard sourceIndexPath != destinationIndexPath else {return}
        
        //get the destintion item
     let destinationItem = itemIdentifier(for: destinationIndexPath)
        
        //get the current snapshot
        var snapshot = self.snapshot()
        
        //handle scenario 2 & 3
        if let destinationItem = destinationItem {
            //get source index and destination index
            if let sourceIndex = snapshot.indexOfItem(sourceItem), let destinationIndex = snapshot.indexOfItem(destinationItem) {
                
                
                //what order should we be inserting the source item
                let isAfter = destinationIndex > sourceIndex && snapshot.sectionIdentifier(containingItem: sourceItem) == snapshot.sectionIdentifier(containingItem: destinationItem)
                
                //first delete the source from the snapshot
                snapshot.deleteItems([sourceItem])
                
                //scenario 2
                if isAfter{
                    snapshot.insertItems([sourceItem], afterItem: destinationItem)
                } else { //scenario 3
                    snapshot.insertItems([sourceItem], beforeItem: destinationItem)
                }
                
            }
        }
        
        
        //handle scerario 4
        //no indexPath at destination section
        else {
            //get the section for the destination index path
            let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
            
            //delete the source item before reinserting it
            snapshot.deleteItems([sourceItem])
            
            //append the source item at the new destinaton
            snapshot.appendItems([sourceItem], toSection: destinationSectionIdentifier)
    }
        apply(snapshot, animatingDifferences: false)
    }
}
