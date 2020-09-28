//
//  LogViewController.swift
//  Chat
//
//  Created by Maria Myamlina on 19.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Loger.printVCLog("ViewController is about to move from 'disappearing'/'disappeared' to 'appearing': \n", #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loger.printVCLog("ViewController moved from 'appearing' to 'appeared': \n", #function)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Loger.printVCLog("ViewController's view is about to layout its subviews: \n", #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Loger.printVCLog("ViewController's view has just laid out its subviews: \n", #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Loger.printVCLog("ViewController is about to move from 'appearing'/'appeared' to 'disappearing': \n", #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Loger.printVCLog("ViewController moved from 'disappearing' to 'disappeared': \n", #function)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}