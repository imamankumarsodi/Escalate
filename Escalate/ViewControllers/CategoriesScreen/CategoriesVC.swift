//
//  CategoriesVC.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import SDWebImage

class CategoriesVC: UIViewController {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var btnNavigationRef: UIButton!
    
    @IBOutlet var tblViewCategories: UITableView!
    
    
    //MARK:- VARIABLES
    //MARK:
    
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isComing = ""
    
    var controllerInstance5 = UIViewController()
    let colorArray = [UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0),UIColor(red: 243.0/255.0, green: 189.0/255.0, blue: 117.0/255.0, alpha: 1.0),UIColor(red: 212.0/255.0, green: 161.0/255.0, blue: 236.0/255.0, alpha: 1.0),UIColor(red: 166.0/255.0, green: 196.0/255.0, blue: 241.0/255.0, alpha: 1.0),UIColor(red: 181.0/255.0, green: 221.0/255.0, blue: 122.0/255.0, alpha: 1.0)]
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var dataArray = NSArray()
    
    var categoriesArray = [CategoriesModel]()
    
    var selectedCategories = [String]()
    
    var  selectedCategoriesName = [String]()
    var topic_id = ""
    
    var categoriesName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isComing == "EDTPROFILE"{
            
            btnNavigationRef.isHidden = false
            viewCategoriesForEdit()
        }
        else if isComing == "VARIFICATION"{
             viewCategories()
        }else{
            
            viewCategories()
        }

      

        // Do any additional setup after loading the view.
    }

    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
    
    //MARK:- METHODS
    //MARK:
    
    //TODO:- WEB SERVICES
    func viewCategories(){
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("genre_list", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    
                    self.dataArray =  responseJson["data"].arrayObject as? NSArray ?? []
                    
                    for item in self.dataArray {
                        
                        let dict = item as? NSDictionary ?? [:]
                        let topic_id = dict.object(forKey: "topic_id") as? String ?? ""
                        let name = dict.object(forKey: "name") as? String ?? ""
                        let icon = dict.object(forKey: "icon") as? String ?? ""
                        let categoryItem = CategoriesModel(name: name, topic_id: topic_id, isSelected: false, icon: icon)
                        self.categoriesArray.append(categoryItem)
                   
                    }
                    
                    print("Tarun")
                    print(self.categoriesArray)
                    
                    self.tblViewCategories.reloadData()
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else{
                        
                        print("do Nothing")
                    }
                    
                }
                
                
            },failure: { (Error) in
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    func viewCategoriesForEdit(){
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
            //print(infoArray)
            let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
            
            //print(infoDict)
            
            let token = infoDict.value(forKey: "token") as? String ?? ""
            
            print(token)
            
            let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
            
            print(user_id)
            
            WebserviceConnection.requestGETURL("genre_listbyid/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    
                    self.dataArray =  responseJson["data"].arrayObject as? NSArray ?? []
                    
                    for item in self.dataArray {
                        
                        let dict = item as? NSDictionary ?? [:]
                        let topic_id = dict.object(forKey: "topic_id") as? String ?? ""
                        let name = dict.object(forKey: "name") as? String ?? ""
                        let isSelected = dict.object(forKey: "status") as? String ?? ""
                        let icon = dict.object(forKey: "icon") as? String ?? ""
                        if isSelected == "1"{
                            
                            let categoryItem = CategoriesModel(name: name, topic_id: topic_id, isSelected: true, icon: icon)
                            self.categoriesArray.append(categoryItem)
                            self.selectedCategories.append(categoryItem.topic_id ?? "")
                            self.selectedCategoriesName.append(categoryItem.name ?? "")
                        }
                        else if isSelected == "0"{
                            
                            let categoryItem = CategoriesModel(name: name, topic_id: topic_id, isSelected: false, icon: icon)
                            self.categoriesArray.append(categoryItem)
                        }
                       
                        
                    }
                    
                    print("Tarun")
                    print(self.categoriesArray)
                    
                    self.tblViewCategories.reloadData()
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else{
                        
                        print("do Nothing")
                    }
                    
                }
                
                
            },failure: { (Error) in
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    
    //MARK:- METHODS
    //MARK:-
    
    
    
    
    func updateCategoriesAPI() {
        

        
        topic_id = selectedCategories.flatMap{ $0 }.joined(separator: ",")
        print(topic_id)
        
        categoriesName = selectedCategoriesName.flatMap{ $0 }.joined(separator: ",")
        print(categoriesName)
        
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        let passDict = ["topic_id":topic_id,
                        "user_id":user_id,
                        "token":token] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("update_topic", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    
                    
                    if self.isComing == "VARIFICATION"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                        
                        
                        
                        
//                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//                        
//                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    else if self.isComing == "EDTPROFILE"{
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        
                        
                    }else{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    
                   
                    
    
                    
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else{
                        
                        print("do Nothing")
                    }
                    
                }
                
                
            },failure: { (Error) in
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    
    
    @IBAction func btnProceedTapped(_ sender: UIButton) {
        
        if isComing == "VARIFICATION"{
            
            
            updateCategoriesAPI()
        
        
        }
        else if isComing == "EDTPROFILE"{
            
             updateCategoriesAPI()
            
            
            
        }else{
            
            updateCategoriesAPI()
        }
    }
    
    
    
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    

}


//MARK:- EXTENTION TABLE VIEW
//MARK:-

extension CategoriesVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblViewCategories.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCell
        
        if dataArray.count > 0{
            
            cell.viewBackCategories.backgroundColor = colorArray[indexPath.row]
            
            
            let dataDict = categoriesArray[indexPath.row] as CategoriesModel
            
            
            let icon = dataDict.icon
            
            print(icon)
            
            
            
            cell.imgCategories.sd_setImage(with: URL(string: icon ?? ""), placeholderImage: UIImage(named: "categories_dialogues"))
            
            
            
            cell.imgCategories.contentMode = .scaleAspectFit
            

            cell.lblCategoriesName.text = dataDict.name
            if dataDict.isSelected == false{
              cell.btnSelectCategoris.setImage(#imageLiteral(resourceName: "categories_untick"), for: .normal)
               cell.imgSelected.image = UIImage(named: "categories_untick")
                
            }
            
            else{
                cell.btnSelectCategoris.setImage(#imageLiteral(resourceName: "categories_tickblue"), for: .normal)
                cell.imgSelected.image = UIImage(named: "categories_tickblue")
            
            }
        
       
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        if categoriesArray[indexPath.row].isSelected!{
            
            categoriesArray[indexPath.row].isSelected = false
            
            if let index = selectedCategories.index(of: categoriesArray[indexPath.row].topic_id ?? ""){
                
                selectedCategories.remove(at: index)
                selectedCategoriesName.remove(at: index)
                
            }
            
            
        }else{
            categoriesArray[indexPath.row].isSelected = true
            selectedCategories.append(categoriesArray[indexPath.row].topic_id ?? "")
            selectedCategoriesName.append(categoriesArray[indexPath.row].name ?? "")
        }
        
        tblViewCategories.reloadData()
        
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}
