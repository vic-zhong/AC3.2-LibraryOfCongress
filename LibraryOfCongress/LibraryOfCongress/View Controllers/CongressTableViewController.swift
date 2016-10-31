//
//  CongressTableViewController.swift
//  LibraryOfCongress
//
//  Created by Victor Zhong on 10/29/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class CongressTableViewController: UITableViewController, UITextFieldDelegate {
	
	var congress = [Congress]()
	var hitsCount = 0
	
	@IBOutlet weak var searchField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadCongress()
		self.searchField.delegate = self
	}
	
	internal func loadCongress(searchString: String = "Mark Twain") {
		APIRequestManager.manager.getCongressData(searchString: searchString) { (data) in
			if data != nil {
				
				if let congress = Congress.congress(from: data!) {
					print("We've got info! \(congress.count)")
					
					self.congress = congress
					
					DispatchQueue.main.async {
						self.tableView.reloadData()
						
						// Pop up alerts, yo!
						if let hitsGotten = Congress.hits(from: data!) {
							self.hitsCount = hitsGotten
							
							var alertMessage = "\(self.hitsCount) "
							if self.hitsCount == 0 {
								alertMessage += "hits returned! Try again!"
							}
							else if self.hitsCount == 1 {
								alertMessage += "hit returned! Displaying result."
							}
							else if self.hitsCount > 19 {
								alertMessage += "hits returned! Displaying the first \(congress.count) results."
							}
							else {
								alertMessage += "hits returned! Displaying results."
							}
							
							let alert = UIAlertController(title: "\"\(searchString)\"", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
							alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
							self.present(alert, animated: true, completion: nil)
						}
					}
				}
			}
		}
	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return congress.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuse", for: indexPath)
		
		let congressAtRow = congress.sorted() {$0.title < $1.title} [indexPath.row]
		
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
				let dataAtRow = congress.sorted() {$0.title < $1.title } [cellIndexPath.row]
				detailViewController.selectedCongressData = dataAtRow
			}
		}
	}
	
	// MARK: - UITextField Stuff
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		if let search = searchField.text {
			loadCongress(searchString: search)
		}
		
		return true
	}
	
}
