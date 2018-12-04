//
//  CustomTabBarController.swift
//  ChatMesenger
//
//  Created by George Heints on 12/4/18.
//  Copyright © 2018 George Heints. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")

        viewControllers = [recentMessagesNavController,
                        CreateNavControllerWithTitle(title: "Calls", imageName: "calls"),
                        CreateNavControllerWithTitle(title: "Groups", imageName: "groups"),
                        CreateNavControllerWithTitle(title: "People", imageName: "people"),
                        CreateNavControllerWithTitle(title: "Settings", imageName: "settings")
        ]
    }

    private func CreateNavControllerWithTitle(title: String, imageName: String) -> UINavigationController{

        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
