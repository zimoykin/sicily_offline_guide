//
//  mainscreenVC.swift
//  Sicily guide
//
//  Created by Дмитрий on 08.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit

class mainscreenVC: UIViewController {
    
    var currentuuid: UUID?

    var myTable: UITableView?
    
    let glCoreData = usCoreData()
    
    let screen_width:   CGFloat = UIScreen.main.bounds.width
    let screen_height:  CGFloat = UIScreen.main.bounds.height
    
    var sights = [Sight]()
    var toDo_list = [ToDo]()
    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sights = glCoreData.getMainScreenInfo()
        toDo_list = glCoreData.getToDoList()
        
        // title label
        let tLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 40, width: screen_width, height: 20))
        tLabel.center.x = view.center.x
        tLabel.text = "Suggested for you"
        tLabel.textAlignment = .center
        view.addSubview(tLabel)
        
        
        myTable = UITableView(frame: CGRect(x: 0, y: tLabel.frame.maxY, width: screen_width, height: screen_height), style: .grouped)
        
        myTable!.register(cell_main.self, forCellReuseIdentifier: "mainCell")

        myTable!.dataSource = self
        myTable!.delegate = self
        
        
        myTable?.reloadData()
        
        view.addSubview(myTable!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(todo_list_changed), name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
        if self.overrideUserInterfaceStyle == UIUserInterfaceStyle.dark {
            myTable!.backgroundColor = .black
        } else {
            myTable!.backgroundColor = .white
        }
    }
    
    
    @objc func todo_list_changed() {
        
        sights = glCoreData.getMainScreenInfo()
        toDo_list = glCoreData.getToDoList()
        
        myTable!.reloadData()
        
    }
    
    
    
}

//MARK: TABLE VIEW
extension mainscreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        UITableViewCell.animate(withDuration: 2) {
            cell.alpha = 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let current_info = sights[indexPath.row]
        
        let cell = myTable!.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! cell_main
        cell.alpha = 0
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 20))
        label.text = current_info.name
//        label.textColor = .black
        
        cell.addSubview(label)
        
        //MARK: star_gray.png
        var isTodo = false
      
        for i in toDo_list {
            if i.uuid == current_info.uuid {
                isTodo = true
                break
            }
        }
      
        
        let image_todo = UIImageView(frame: CGRect(x: screen_width - 40, y: 0, width: 18, height: 18))
    
        if isTodo {
            image_todo.image = UIImage(named: "star_yellow.png")
        } else {
            image_todo.image = UIImage(named: "star_gray.png")
        }
        
        cell.addSubview(image_todo)

        //UNESCO logo
        if current_info.unesco {
            let image_unesco = UIImageView(frame: CGRect(x: screen_width - image_todo.frame.width - 80, y: 0, width: 18, height: 18))
            image_unesco.image              = UIImage(named: "UNESCO.png")
            image_unesco.contentMode        = .scaleAspectFill
            image_unesco.backgroundColor    = .white
            image_unesco.layer.cornerRadius = image_unesco.frame.width/2
            image_unesco.clipsToBounds      = true
            cell.addSubview(image_unesco)
            image_unesco.center.y = cell.frame.height/2
        }
        
        
        
        
        cell.uuid = current_info.uuid
        
        label.center.y = cell.frame.height/2
        image_todo.center.y = cell.frame.height/2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentcell = tableView.cellForRow(at: indexPath) as! cell_main
        
        if currentcell.uuid != nil {
           
            currentuuid = currentcell.uuid
            performSegue(withIdentifier: "segue_detail_obj", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ((segue.identifier == "segue_detail_obj") && (currentuuid != nil)) {
                let vc = segue.destination as! detailObjVC
                vc.uuid = currentuuid
        } else {
            fatalError()
        }
    }
    

    
}

class cell_main: UITableViewCell {
    var uuid: UUID?
    
}
