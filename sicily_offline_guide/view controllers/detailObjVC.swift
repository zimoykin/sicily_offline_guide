//
//  detailObjVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 09.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit

class detailObjVC: UIViewController {
    
    var uuid: UUID?
    var sight: Sight?
    
    var isToDo: Bool = false
    
    let screen_width    = UIScreen.main.bounds.width
    let screen_height   = UIScreen.main.bounds.height
    
    var ctitle:             UITextView?
    var full_description:   UITextView?
    var mainScroll:         UIScrollView?
    var image_view:         UIImageView?
    var todo: UIImageView?
    
    let glUseCoreData = usCoreData()
    
    fileprivate func setCancelButton() {
        //        BUTTON
        let cancelBTN = UIButton(type: .close)
        
        cancelBTN.frame = CGRect(x: screen_width - 80, y: screen_height - 80, width: 70, height: 70)
        
        cancelBTN.setTitle("close", for: .normal)
        cancelBTN.setTitleColor(.white, for: .normal)
        cancelBTN.addTarget(self, action: #selector(pushcancel), for: .touchUpInside)
        cancelBTN.backgroundColor = UIColor(displayP3Red: 255/255, green: 205/255, blue: 125/255, alpha: 1)
        cancelBTN.tintColor = .white
        
        cancelBTN.layer.cornerRadius = cancelBTN.frame.width / 2
        
        let cancelBTN_2 = UIButton(type: .custom)
        
        cancelBTN_2.frame = CGRect(x: screen_width - 90, y: screen_height - 90, width: 90, height: 90)
        
        cancelBTN_2.setTitle("close", for: .normal)
        cancelBTN_2.setTitleColor(.white, for: .normal)
        cancelBTN_2.addTarget(self, action: #selector(pushcancel), for: .touchUpInside)
        cancelBTN_2.backgroundColor = .white //UIColor(displayP3Red: 201/255, green: 255/255, blue: 251/255, alpha: 1)
        cancelBTN_2.tintColor = .white
        
        cancelBTN_2.layer.cornerRadius = cancelBTN_2.frame.width / 2
        
        view.addSubview(cancelBTN_2)
        view.addSubview(cancelBTN)
    }
    
    fileprivate func setScrollView() {
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        mainScroll!.backgroundColor = UIColor(displayP3Red: 255/255, green: 250/255, blue: 184/255, alpha: 1)
        view.addSubview (mainScroll!)
    }
    
    @objc func pushcancel() {
        
//        Device.vibrate()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    class UITapGestureRecognizer_uuid: UITapGestureRecognizer {
        var uuid: UUID?
    }
    
    @objc func addToDo (sender: UITapGestureRecognizer_uuid) {
        
        if uuid != nil {
            
            glUseCoreData.setToDo(uuid: uuid!, delete: isToDo)
            isToDo = false
            
            let todo_list = glUseCoreData.getToDoList()
            
            for i in todo_list {
                
                if i.uuid == uuid {
                    isToDo = true
                    break
                }
            }
            
            if isToDo {
                todo!.image = UIImage(named: "star_yellow.png")
            } else {
                todo!.image = UIImage(named: "star_gray.png")
            }
            
            Device.vibrate()
            
            UIView.animate(withDuration: 1) {
                self.todo!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                
                if self.isToDo {
                    self.ctitle?.backgroundColor = .yellow
                } else {
                    self.ctitle?.backgroundColor = .gray
                }
            }
            
            UIView.animate(withDuration: 1) {
                self.todo!.transform = CGAffineTransform.identity
                self.ctitle?.backgroundColor = .white
            }
            

            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil, userInfo: nil)
  
        }
    }
    
//    MARK: LOGO UNESCO
    func setImageUNESCO () {
        let image_unesco = UIImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        image_unesco.image = UIImage(named: "UNESCO.png")
        image_unesco.clipsToBounds = true
        image_unesco.contentMode = .scaleAspectFill
        
        image_unesco.frame.origin.y = (image_view?.frame.maxY ?? view.frame.midY) - 65
        image_unesco.frame.origin.x = screen_width - 65
        
        image_unesco.alpha = 0.1
        
        mainScroll!.addSubview(image_unesco)
       
        
        UIView.animate(withDuration: 3) {
            image_unesco.alpha = 0.9
        }
    }
    
    fileprivate func setBtnToDo() {
        //MARK: ADD TODO BuTTON
        
       // ctitle?.frame.minX
        
        todo = UIImageView(frame: CGRect(x:  20, y: screen_height - 90, width: 25, height: 25))
        
        if isToDo {
           todo!.image = UIImage(named: "star_yellow.png")
        } else {
            todo!.image = UIImage(named: "star_gray.png")
        }
        
        let view_todo = UIView()
        view_todo.frame = CGRect(x: 25, y: screen_height - 90, width: 25, height: 25)
        
        view_todo.backgroundColor = .white
        view_todo.tintColor = .white
        
        view_todo.layer.cornerRadius = view_todo.frame.width / 2
        
        todo?.frame.origin.x = (ctitle?.frame.minX)! - 25
        
        todo!.center = ctitle!.center
        view_todo.center = todo!.center
        
        todo?.frame.origin.x = (ctitle?.frame.minX)! - 25
        view_todo.frame.origin.x = (ctitle?.frame.minX)! - 25
        
        UIView.animate(withDuration: 1) {
            self.view.addSubview(view_todo)
            self.view.addSubview(self.todo!)
        }
        
        let tap_on_star = UITapGestureRecognizer_uuid(target: self, action: #selector(self.addToDo))
        tap_on_star.uuid = self.uuid
        view_todo.addGestureRecognizer(tap_on_star)
        
    }
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollView()
        setCancelButton()
        
        isToDo = glUseCoreData.checkItInToDo(uuid: uuid!)
        
        sight = glUseCoreData.getObjByUUID(uuid: uuid!)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            self.ctitle = UITextView(frame: CGRect(x: 0, y: 0, width: (7 * max((self.sight?.name!.count)!, 7)), height: 20))
            
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 40
            
            let text = NSAttributedString(string: self.sight!.name!,
                                          attributes: [NSAttributedString.Key.paragraphStyle: style])
        
            self.ctitle!.attributedText = text
            
            self.ctitle!.alpha = 0.1
            self.ctitle?.backgroundColor = .white
            self.ctitle?.textColor = .black
            self.ctitle?.isUserInteractionEnabled = false
            
            self.ctitle?.translatesAutoresizingMaskIntoConstraints = true
            self.ctitle?.sizeToFit()
            self.ctitle?.isScrollEnabled = false
            
            self.ctitle!.center  = self.view.center
            self.view!.addSubview(self.ctitle!)
            
            UIView.animate(withDuration: 1) {
                self.ctitle!.alpha = 1
                self.ctitle!.layer.cornerRadius = self.ctitle!.frame.width / 10
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                UIView.animate(withDuration: 1) {
                    self.ctitle!.frame.origin.y = 40
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                //MARK: IMAGE
                self.image_view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.screen_width, height: self.screen_width))
                
                //if no photo - use universal
                if UIImage(named: self.sight!.imagename!) == nil {
                    self.image_view!.image = UIImage(named: "nophoto.png")
                } else {
                   self.image_view!.image = UIImage(named: self.sight!.imagename!)
                }
                
                
                self.image_view?.contentMode = .scaleAspectFill
                self.image_view!.center  = self.view.center
                self.image_view?.frame.origin.y = 0
                self.image_view!.alpha = 0.1
                
                self.mainScroll!.addSubview(self.image_view!)
                self.mainScroll?.bringSubviewToFront(self.ctitle!)
                
                UIView.animate(withDuration: 1) {
                    self.image_view!.alpha = 1
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                UIView.animate(withDuration: 1) {
//                    self.image_view?.frame.origin.y -= (self.image_view?.frame.minY)! - (self.ctitle?.frame.maxY)!
                  //  if nophoto {
                        self.image_view?.frame.origin.y = 0
                   // }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                
                self.full_description = UITextView(frame: CGRect(x: 0, y: 0, width: self.screen_width, height: 200))
                
                self.full_description?.text = self.sight?.fulldescription != "" ? self.sight?.fulldescription : " no information "
                
                self.full_description?.center = self.mainScroll!.center
                self.full_description?.backgroundColor = .white
                self.full_description?.textColor = .black
                
                self.mainScroll?.alpha = 0.1
                self.mainScroll?.addSubview(self.full_description!)
                
                self.full_description?.isUserInteractionEnabled = false
                
                UIView.animate(withDuration: 1) {
                    self.mainScroll?.alpha = 1
                    self.full_description?.frame.origin.y = (self.image_view?.frame.maxY)! //+ (self.ctitle?.frame.maxY)!
                    
                    self.full_description?.translatesAutoresizingMaskIntoConstraints = true
                    self.full_description?.sizeToFit()
                    self.full_description?.isScrollEnabled = false
                    
                    self.mainScroll?.isScrollEnabled = true
                    self.mainScroll?.contentSize = CGSize(width: self.screen_width, height: 70 + (self.full_description?.frame.maxY)!)
                    
                }
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.setBtnToDo()
                if self.sight?.unesco ?? false {
                    self.setImageUNESCO()
                }
            }
            
        }
        
    }
}
