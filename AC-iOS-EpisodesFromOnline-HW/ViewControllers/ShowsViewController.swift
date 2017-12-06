//
//  ShowsViewController.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 11/30/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var tvShows = [ShowInfo]() {
        didSet {
            tableView.reloadData()
        }
    }

    var searchTerm = "" {
        didSet {
            loadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    func loadData() {
        let urlString = "http://api.tvmaze.com/search/shows?q=\(searchTerm)"
        let completion: ([ShowInfo]) -> Void = {(onlineShows: [ShowInfo]) in
            dispatchMain {
                self.tvShows = onlineShows
                self.tableView.reloadData()
            }
        }
        
        ShowsAPIClient.manager.getShows(from: urlString,
                                        completionHandler: completion,
                                        errorHandler: { [weak self] error in
                                            self?.showAlert(error: error)
                                            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath)
        let tvShow = tvShows[indexPath.row]
        cell.textLabel?.text = tvShow.show.name
        cell.detailTextLabel?.text = tvShow.show.rating.average?.description ?? "No Rating Available."
        cell.imageView?.image = nil //Gets rid of flickering
        guard let imageUrlStr = tvShow.show.image?.medium else {
            return cell
        }
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.imageView?.image = onlineImage
            cell.setNeedsLayout() //Makes the image load as soon as it's ready
        }
        ImageAPIClient.manager.getImage(from: imageUrlStr,
                                        completionHandler: completion,
                                        errorHandler: {print($0)})
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
    
    func showAlert(error: AppError) {
        let alert = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        dispatchMain { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

func dispatchMain(_ task: @escaping () -> Void) {
    if Thread.isMainThread {
        task()
    } else {
        DispatchQueue.main.async {
            task()
        }
    }
}







