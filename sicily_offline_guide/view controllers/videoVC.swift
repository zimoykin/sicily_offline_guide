//
//  videoVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 27.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit
import AVKit


class videoVC: UIViewController {

    let screen_width    = UIScreen.main.bounds.width
    let screen_height   = UIScreen.main.bounds.height
    
    var player:         AVPlayer = AVPlayer()
    var playerLayer:    AVPlayerLayer = AVPlayerLayer()
    
    var sound_btn = UIButton()
    
    var firstPage:  Bool = true
    var novideo:    Bool = UserDefaults.standard.bool(forKey: "novideo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //zingaro.MP4
        let filePath = Bundle.main.path(forResource: "sicily_guide_intro.mp4", ofType: nil)
        player = AVPlayer(url: URL(fileURLWithPath: filePath!))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        playerLayer.videoGravity = .resizeAspectFill
        
        player.play()
        
        //      MARK: swipe for close
        let swipe_up = UISwipeGestureRecognizer(target: self, action: #selector(swipe_up_action))
        swipe_up.direction = .up
        view.addGestureRecognizer(swipe_up)
        self.view.layer.addSublayer(playerLayer)
        
        //sicily label
        let sicily = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        sicily.text = "SICILY GUIDE"
        
        sicily.backgroundColor = .lightGray
        sicily.textColor = .black
        sicily.alpha = 1
        sicily.font = UIFont(name: "HELVETICA", size: 14)
        sicily.sizeToFit()
        sicily.center = view.center
        view.addSubview(sicily)
        
        UIView.animate(withDuration: 6) {
            sicily.alpha = 0
        }
        
//        let nonshow_btn = UIButton(frame: CGRect(x: 20, y: 40, width: 25, height: 25))
//        nonshow_btn.setTitle("Don't show it again", for: .normal)
//        nonshow_btn.setTitleColor(.white, for: .normal)
//        nonshow_btn.addTarget(self, action: #selector(nonshow_push), for: .touchUpInside)
//        nonshow_btn.sizeToFit()
//        view.addSubview(nonshow_btn)
//
        let swipe_label = UILabel(frame: CGRect(x: 0, y: screen_height+40, width: 20, height: 20))
        swipe_label.text = "Swipe up to close"
        swipe_label.font = UIFont(name: "Helvetica", size: 17)
        swipe_label.sizeToFit()
        swipe_label.textColor   = .white
        swipe_label.center.x    = view.center.x
        view.addSubview(swipe_label)
        
        UIView.animate(withDuration: 3) {
            swipe_label.frame.origin.y = self.screen_height - 50
        }
        
        touchSound()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//
}
    
    @objc func swipe_up_action () {
        playerDidFinishPlaying()
    }
    
    @objc func nonshow_push () {
        
        UserDefaults.standard.set(true, forKey: "novideo")
        closeView()
        
    }

    @objc func touchSound () {
        
        player.isMuted = !player.isMuted
        
        sound_btn.removeFromSuperview()
        
        sound_btn.backgroundColor = .lightGray
        
        sound_btn = UIButton(frame: CGRect(x: screen_width - 65, y: screen_height - 65, width: 65, height: 65))
        sound_btn.imageView?.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
        sound_btn.imageView?.contentMode = .scaleAspectFill
        
        let mImage = player.isMuted ? UIImage(named: "sound_off.png") : UIImage(named: "sound_on.png")
        sound_btn.setImage(mImage, for: .normal)
        
        
        sound_btn.addTarget(self, action: #selector(touchSound), for: .touchUpInside)
        view.addSubview(sound_btn)
        
    }
    
    @objc func playerDidFinishPlaying () {
        
        UIView.animate(withDuration: 2) {
            self.view.alpha = 0
        }
        closeView()
    }
    
    @objc func closeView () {
        
        self.dismiss(animated: true) {
            self.player.pause()
//            if self.firstPage {
                self.performSegue(withIdentifier: "showMainScreen", sender: self)
//            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMainScreen" {
            return
        }
    }

    
}
