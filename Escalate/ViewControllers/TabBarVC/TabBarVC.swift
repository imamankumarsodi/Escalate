//
//  TabBarVC.swift
//  Tapitt
//
//  Created by Dacall soft on 25/10/17.
//  Copyright © 2017 Dacall soft. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController
{
    
    
    var controllerInstance4 =  UIViewController()
    
    let arrImageNormal : NSArray = ["home_icon_inselected","home_search_unselected","home_mic_unselected","home_shat_unselected","home_unselected_prfl"]
    let arrImageSelected : NSArray = ["home_icon_selected","home_selected_search","home_selected_mic","home_selected_chat","home_selected_prfl"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        setTabBarSelectedImage(normalArr: arrImageNormal, selectedArr: arrImageSelected)
        
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.white
        //UITabBar.appearance().unselectedItemTintColor = UIColor(red: 0/255, green: 156/255, blue: 128/255, alpha: 1.0)

    }
   
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(TabBarVC.changeTabbarImageArrayToNormal(not:)), name: NSNotification.Name(rawValue: "TabbarImageChangedToNormal"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(TabBarVC.changeTabbarImageArrayToSelected(not:)), name: NSNotification.Name(rawValue: "TabbarImageChangedToSelected"), object: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillLayoutSubviews()
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        var kBarHeight:CGFloat
        if screenHeight == 812{
            kBarHeight = 94
        }else{
            kBarHeight = 64
            
        }
        var tabFrame: CGRect = tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = view.frame.size.height - kBarHeight
        tabBar.frame = tabFrame
    }
    
    

//    override func viewWillLayoutSubviews()
//    {
//        let kBarHeight : CGFloat = 65
//        var tabFrame: CGRect = tabBar.frame
//        tabFrame.size.height = kBarHeight
//        tabFrame.origin.y = view.frame.size.height - kBarHeight
//        tabBar.frame = tabFrame
//    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setTabBarSelectedImage(normalArr: NSArray, selectedArr : NSArray)
    {
        
        for (index, _) in (self.tabBar.items?.enumerated())!
        {
            print(index)
            let tabItem2  = self.tabBar.items![index]
            tabItem2.selectedImage = UIImage(named:selectedArr.object(at: index) as! String )?.withRenderingMode(.alwaysOriginal)
            tabItem2.image=UIImage(named:normalArr.object(at: index) as! String )?.withRenderingMode(.alwaysOriginal)
            //tabItem2.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)

        }
    }
    
//    @objc func changeTabbarImageArrayToNormal(not: Notification)
//    {
//        setTabBarSelectedImage(normalArr: arrImageNormal, selectedArr: arrImageSelected)
//    }
//
//    @objc func changeTabbarImageArrayToSelected(not: Notification)
//    {
//        setTabBarSelectedImage(normalArr: arrImageNormalAfter, selectedArr: arrImageSelectedAfter)
//    }
//
//    override func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem])
//    {
//        print("gedjioj ")
//    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
//    {
//
//        if item.title ?? "" == ""
//        {
//            let secondItemView = tabBar.subviews[3]
//
//            let secondItemImageView = secondItemView.subviews.first as! UIImageView
//            secondItemImageView.contentMode = .center
//
//        //    CommonMethod.flipButton(btn:secondItemImageView, img: UIImage())
//        }
//        else
//        {
//         //   CommonMethod.flipButton(btn: self.secondItemImageView, img: UIImage())
//        }
//
//    }
}
