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

    @IBOutlet weak var myTable: UITableView!
    
    let glCoreData = usCoreData()
    
    let screen_width:   CGFloat = UIScreen.main.bounds.width
    let screen_height:  CGFloat = UIScreen.main.bounds.height
    
    var sights = [Sight]()
    var toDo_list = [ToDo]()
    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        myTable.dataSource = self
        myTable.delegate = self
        
        sights = glCoreData.getMainScreenInfo()
        toDo_list = glCoreData.getToDoList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(todo_list_changed), name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @objc func todo_list_changed() {
        
        sights = glCoreData.getMainScreenInfo()
        toDo_list = glCoreData.getToDoList()
        
        myTable.reloadData()
        
    }
    
    
    
}

//MARK: TABLE VIEW
extension mainscreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let current_info = sights[indexPath.row]
        
        let cell = myTable.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! cell_main
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 20))
        label.text = current_info.name
        label.textColor = .black
        
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

        cell.uuid = current_info.uuid
        
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
