//
//  ViewController.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 28.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import UIKit
import SDWebImage
import PFNavigationDropdownMenu

class ViewController: UIViewController {
    /// Model for sending HTTP GET requests.
    var productHuntApi = Api()
    
    /// Data of posts.
    var posts = [Post]()
    /// Data of topics (for dropdown menu).
    var topics = [Topic]()
    
    var currentTopic: Topic?
    var currentPost: Post?
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Control for pull-to-refresh.
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding UIRefreshControl for pull-to-refresh feature
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadTopics()
    }
    
    func loadPosts(for topic: Topic) {
        DispatchQueue.main.async {
            if let posts = self.productHuntApi.getPosts(by: topic.slug) {
                self.posts = posts
            }
            self.tableView.reloadData()
        }
    }
    
    func loadTopics() {
        if let topics = self.productHuntApi.getTopics() {
            self.topics = topics
        }
        
        // Loading posts for "Tech" - by default
        loadPosts(for: Topic(id: 0, name: "Tech", slug: "tech"))
        
        // Sets some UI things... for dropdown list
        setUpUi()
    }
    
    private func setUpUi() {
        // Setting up some look and feel for UINavigationBar...
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Creating strings array for PFNavigationDropdownMenu
        var topicStrings = [String]()
        for someTopic in topics {
            topicStrings.append(someTopic.name)
        }
        
        let menuView = PFNavigationDropdownMenu(frame: CGRect(x: 0, y: 0, width: 300, height: 44), title: "Tech", items: topicStrings, containerView: self.view)!
        menuView.cellTextLabelColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        // Setting event handler (
        menuView.didSelectItemAtIndexHandler = { (indexPath: UInt) -> () in
            self.currentTopic = self.topics[Int(indexPath)]
            self.loadPosts(for: self.currentTopic!)
        }
        
        // ...and imported drop-down menu
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        navigationItem.titleView = menuView
    }
    
    
    @objc func refresh(sender: AnyObject) {
        refreshBegin(refreshEnd: {(x: Int) -> () in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(refreshEnd: @escaping (Int) -> ()) {
        DispatchQueue.global().async() {
            sleep(2)
            
            if let topic = self.currentTopic {
                self.loadPosts(for: topic)
            }
            
            DispatchQueue.main.async() {
                refreshEnd(0)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.receivedData = currentPost
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! ProductTableViewCell
        
        cell.name?.text = posts[indexPath.row].title
        cell.tagline?.text = posts[indexPath.row].description
        cell.votesCount?.text = String(posts[indexPath.row].votesCount)
        cell.imageView?.sd_setImage(with: URL(string: posts[indexPath.row].picture.imageUri))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPost = posts[indexPath.row]
        performSegue(withIdentifier: "showDetailView", sender: self)
    }
}
