//
//  settingsVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 20.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit

class settingsVC: UIViewController {
    
    let screen_width    = UIScreen.main.bounds.width
    let screen_height   = UIScreen.main.bounds.height
    
    let mode_switch = UISwitch()
    let tDarkMode   = UILabel()
    let view_sub_dm = UIScrollView()
    let view_sub    = UIScrollView()
    
    override func viewWillAppear(_ animated: Bool) {
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        
        mode_switch.isOn = UserDefaults.standard.bool(forKey: "darkMode")
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
 
        
        var back_image: UIImage = UIImage(named: "nophoto.png")!
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            var pics: Array<String> = []
            
            for item in items {
                if item.description.contains("jpg") {
                    pics.append(item)
                    
                }
            }
            
            let num_random = Int.random(in: 0...pics.count-1)
            back_image = UIImage(named: pics[num_random])!
        } catch {
            print(error)
        }
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: screen_width-10, height: screen_height-10))
        
        image.image = back_image
        image.clipsToBounds =  true
        image.contentMode = .scaleAspectFill
        
        image.center = view.center
        
        view.addSubview(image)
        
//        MARK: Blur background
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
//        MARK: add author image
        
        let auth_image = UIImageView(frame: CGRect(x: 0, y: 0, width: screen_width/3, height: screen_width/3))
        auth_image.image = UIImage(named: "dev.png")
        auth_image.clipsToBounds = true
        auth_image.layer.borderColor = UIColor.yellow.cgColor
        auth_image.layer.borderWidth = 1
        auth_image.alpha = 0
        auth_image.center = view.center
        
        view.addSubview(auth_image)
        
        
//        MARK: add button email
        
        let email_btn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        email_btn.setTitle("zimoykin@gmail.com", for: .normal)
        email_btn.setTitleColor(UIColor.red, for: .focused)
        email_btn.setTitleColor(UIColor.white, for: .normal)
//        "zimoykin@gmail.com"
        email_btn.sizeToFit()
        email_btn.alpha = 0
        email_btn.addTarget(self, action: #selector(pushEmailLink), for: .touchUpInside)
       
        view.addSubview(email_btn)
        
        email_btn.center = view.center
        
        UIView.animate(withDuration: 1) {
            auth_image.alpha = 1
            email_btn.alpha = 1
            
            auth_image.layer.cornerRadius = auth_image.frame.width/2
            
            auth_image.frame.origin.y   = self.screen_height/8
            email_btn.frame.origin.y    = self.screen_height/8 + auth_image.frame.height
        }
        
//        MARK: dev txtview
            let txtDev = UITextView(frame: CGRect(x: 0, y: email_btn.frame.maxY, width: screen_width-20, height: 100))
            txtDev.text = "Hi everyone! \nThis is my second application on SWIFT. \nIn this app I used table, collection, map.\nEvery view i did programatycally. \nEnjoy."
            
            txtDev.backgroundColor = nil
            txtDev.textColor = .white
            txtDev.textAlignment = .center
            txtDev.font = UIFont(name: "Helvetica", size: 14)
            txtDev.isUserInteractionEnabled = false
            txtDev.sizeToFit()
            txtDev.alpha = 0
            
            view.addSubview(txtDev)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                UIView.animate(withDuration: 1) {
                    txtDev.center.x = self.view.center.x
                    txtDev.alpha = 1
                    
                }
            }
            
            setSettings(txtDev_maxY: txtDev.frame.maxY)
            setVideoBtn()
            
    }
    
    
    @objc func showVideo () {
        performSegue(withIdentifier: "showVideo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showVideo" {
            
            let vc = segue.destination as! videoVC
            vc.firstPage = false
            
            return
        }
    }
    
    func setVideoBtn () {
        
        view_sub.frame = CGRect(x: 0, y: view_sub_dm.frame.maxY + 20, width: screen_width-10, height: 50)
        view_sub.backgroundColor    = .lightGray
        view_sub.layer.cornerRadius = 30
        view_sub.alpha = 0.5
        
        view.addSubview(view_sub)
        
        let videoBtn = UIButton(frame: CGRect(x: 0, y: view_sub.frame.maxY, width: 20, height: 20))
        videoBtn.setTitle("Play video (intro)", for: .normal)
        videoBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 16)!
        videoBtn.setTitleColor(.black, for: .normal)
        videoBtn.sizeToFit()
        videoBtn.frame.origin.x = 30
        videoBtn.center.y = self.view_sub.center.y

        videoBtn.addTarget(self, action: #selector(showVideo), for: .touchUpInside)
        
        view.addSubview(videoBtn)
        
        UIView.animate(withDuration: 1.5) {
            videoBtn.center.y = self.view_sub.center.y
        }
        
    }
    
    func setSettings (txtDev_maxY: CGFloat) {
        
        view_sub_dm.frame = CGRect(x: 0, y: txtDev_maxY, width: screen_width-10, height: 50)
        view_sub_dm.backgroundColor    = .lightGray
        view_sub_dm.layer.cornerRadius = 30
        view_sub_dm.alpha = 0.5
        
        
        view.addSubview(view_sub_dm)
        
        view_sub_dm.center.x = view.center.x
        
        // MARK: Switch
        tDarkMode.frame = CGRect(x: 30, y: view_sub_dm.center.y, width: 45, height: 45)
        tDarkMode.text  = "Use dark mode"
        tDarkMode.font  = UIFont(name: "Helvetica", size: 16)
        tDarkMode.sizeToFit()
       
        if mode_switch.isOn {
            tDarkMode.textColor = .black
        } else {
            tDarkMode.textColor = .white
        }
    
        view.addSubview(tDarkMode)
        
        mode_switch.frame = CGRect(x: screen_width - mode_switch.frame.width - 30, y: view_sub_dm.center.y, width: 10, height: 10)
        mode_switch.alpha = 1
        mode_switch.addTarget(self, action: #selector(changed_mode), for: .touchUpInside)
        view.addSubview(mode_switch)
        
        UIView.animate(withDuration: 1.5) {
            self.mode_switch.center.y   = self.view_sub_dm.center.y
            self.tDarkMode.center.y     = self.view_sub_dm.center.y
        }
        
    }
}


extension settingsVC {
    
    @objc func pushEmailLink () {
        
        let myEmailUrl = URL(string: "mailto:zimoykin@gmail.com")!
        UIApplication.shared.open(myEmailUrl as URL, options: [:], completionHandler: nil)
    }
    
    @objc func changed_mode() {
        UserDefaults.standard.set(mode_switch.isOn, forKey: "darkMode")
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
        
        if mode_switch.isOn {
              tDarkMode.textColor = .black
          } else {
              tDarkMode.textColor = .white
          }
    }
    
    func getimage() {
        
        var fileListArray: Array<String> = []
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = dirPaths[0]
        //let folder = documentDirectory.appending("/pics")
        
        do
        {
            let fileList = try FileManager.default.contentsOfDirectory(atPath: documentDirectory)
            for file in fileList {
                fileListArray.append(file)
            }
           
        }
        catch
        {
          print(error)
        }
    }
    
}
