//
//  ConversationsListViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 25.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationsListViewController: LogViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let reuseIdentifier = "Conversation Cell"
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
       return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupTableView()
    }
    
    
    // MARK: - Navigation
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 245/250, green: 245/250, blue: 245/250, alpha: 1.0)
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SettingsIcon"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 84/250, green: 84/250, blue: 88/250, alpha: 0.65)
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let profileImage = ProfileImageView()
        profileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileImage.contentView.backgroundColor = navigationController?.navigationBar.backgroundColor

        let rightButton = ButtonWithTouchSize()
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.layer.cornerRadius = rightButton.bounds.width / 2
        rightButton.clipsToBounds = true
        rightButton.addTarget(self, action: #selector(profileMenuTapped), for: .touchUpInside)
        profileImage.addSubview(rightButton)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImage)
    }
    
    @objc func profileMenuTapped() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileController = storyboard.instantiateViewController(withIdentifier: "Profile VC")
        let navigationVC = UINavigationController(rootViewController: profileController)
        present(navigationVC, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - TableView
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = 88
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.sectionFooterHeight = 0

        tableView?.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionOnlineCount = 0
        var sectionOfflineCount = 0
        
        for friend in ChatHelper.friends {
            if friend.isOnline {
                sectionOnlineCount += 1
            } else {
                sectionOfflineCount += 1
            }
        }
        
        switch section {
        case 0:
            return sectionOnlineCount
        case 1:
            return sectionOfflineCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ConversationTableViewCell
        
        cell?.configure(with: ChatHelper.friends[indexPath.row + indexPath.section * self.tableView(tableView, numberOfRowsInSection: 0)])

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = storyboard.instantiateViewController(withIdentifier: "Conversation VC") as? ConversationViewController
        
        conversationController?.name = (self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell)?.nameLabel.text
        
        if (self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell)?.messageLabel.text != "No messages yet" {
            conversationController?.lastMessage = (self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell)?.messageLabel.text
        }
        
        guard let subview = (self.tableView(tableView, cellForRowAt: indexPath) as? ConversationTableViewCell)?.profileImage else { return }
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let viewWithImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))

        subview.layer.cornerRadius = viewWithImage.bounds.width / 2
        viewWithImage.clipsToBounds = true
        viewWithImage.image = subview.image
        viewWithImage.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: viewWithImage.topAnchor),
            subview.bottomAnchor.constraint(equalTo: viewWithImage.bottomAnchor),
            subview.trailingAnchor.constraint(equalTo: viewWithImage.trailingAnchor),
            subview.leadingAnchor.constraint(equalTo: viewWithImage.leadingAnchor),
            subview.heightAnchor.constraint(equalToConstant: 36),
            subview.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        conversationController?.image = viewWithImage

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(conversationController ?? UIViewController(), animated: true)
    }
}
