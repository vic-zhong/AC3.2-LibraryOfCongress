//
//  CongressTableViewController.swift
//  LibraryOfCongress
//
//  Created by Victor Zhong on 10/29/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class CongressTableViewController: UITableViewController {
	
	var congress = [Congress]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadCongress()
	}
	
	internal func loadCongress() {
		APIRequestManager.manager.getCongressData { (data) in
			if data != nil {
				
				if let congress = Congress.congress(from: data!) {
					print("We've got info! \(congress)")
					
					self.congress = congress
					
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
		}
	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return congress.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
		
		let congressAtRow = congress[indexPath.row]
		
		cell.textLabel?.text = congressAtRow.title
		
		// Code for Thumbnail Images
		APIRequestManager.manager.downloadImage(urlString: congressAtRow.thumbURL) { (returnedData: Data) in
			DispatchQueue.main.async {
				cell.imageView?.image = UIImage(data: returnedData)
				cell.setNeedsLayout()
			}
		}
		
		return cell
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tappedCongressCell : UITableViewCell = sender as? UITableViewCell {
			if segue.identifier == "detailSegue" {
				let detailViewController : DetailViewController = segue.destination as! DetailViewController
				let cellIndexPath: IndexPath = self.tableView.indexPath(for: tappedCongressCell)!
				let dataAtRow = congress[cellIndexPath.row]
				detailViewController.selectedCongressData = dataAtRow
			}
		}
	}
	
}
