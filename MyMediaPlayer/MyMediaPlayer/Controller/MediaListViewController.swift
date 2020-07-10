//
//  ViewController.swift
//  MyMediaPlayer
//
//  Created by Ameer Shaikh on 04/07/2020.
//  Copyright © 2020 SAED. All rights reserved.
//

import UIKit

class MediaListViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataSource = MediaList()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _loadDataSource()
    }
    
    func _loadDataSource() {
        ServerCommunication.chapterContents(chapterID: "125",completion:  { (mediaArray) in
            self.dataSource = mediaArray ?? []
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCellIdentifier", for: indexPath) as! MediaTableViewCell
        let media = dataSource[indexPath.row]
        // configure
        cell.mediaTitle.text = media.audioname
        cell.loadImage(imageUrl: media.logoMin)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // present the player
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(identifier: "MediaPlayerViewController") as? MediaPlayerViewController else {
            return
        }
        vc.mediaArray = dataSource
        vc.position = position
        present(vc, animated: true)
    }
}

