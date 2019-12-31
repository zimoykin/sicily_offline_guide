

import UIKit

class toDoVC: UIViewController {
    
    let glMainCD = usCoreData()
    
    var cTitle: UITextView?
    var edditing_mode = false
    
    let edit_btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let view_btn = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var dataArray:          Array <ToDo> = []
    let screen_width:       CGFloat = UIScreen.main.bounds.width
    let screen_height:      CGFloat = UIScreen.main.bounds.height
    var todo_Collection:    UICollectionView?
    
    var cur_uuid: UUID?
    
    override func viewWillAppear(_ animated: Bool) {
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
        
        if self.overrideUserInterfaceStyle == UIUserInterfaceStyle.dark {
            todo_Collection!.backgroundColor = .black
        } else {
            todo_Collection!.backgroundColor = .white
        }
    }
    
    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = glMainCD.getToDoList()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: (screen_width-20) / 3, height: (screen_width-20) / 3)
        collectionViewLayout.minimumLineSpacing = 10

        todo_Collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height), collectionViewLayout: collectionViewLayout)
        todo_Collection?.register(TodoCell.self, forCellWithReuseIdentifier: "toDoCell")
        
        todo_Collection!.delegate    = self
        todo_Collection!.dataSource  = self
        
        todo_Collection?.reloadData()
        
        view.addSubview(todo_Collection!)
        
        cTitle = UITextView(frame: CGRect(x: 0, y: 0, width: screen_width, height: 20))
        cTitle?.text        = "Things you must do in sicily!"
        cTitle?.sizeToFit()
        cTitle?.center.x      = view.center.x
        cTitle?.textAlignment = .center
        cTitle?.alpha       = 0
        cTitle?.isUserInteractionEnabled = false
        
        view.addSubview(cTitle!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.setButtonEditCollection()
        }
        
        UIView.animate(withDuration: 1) {
            self.cTitle?.frame.origin.y = (self.todo_Collection?.frame.origin.y)! + 40
            self.todo_Collection?.frame.origin.y = (self.todo_Collection?.frame.origin.y)! +  (self.cTitle?.frame.height)! + 40 + 5
            
        }
        
        UIView.animate(withDuration: 1) {
            self.cTitle?.frame = CGRect(x:  0, y:  (self.cTitle?.frame.origin.y)!, width: self.screen_width, height:  (self.cTitle?.frame.height)!)
            self.cTitle?.alpha = 1
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(todowasChanged), name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil)
        
        if dataArray.count == 0 {
            let alert = UIAlertController(title: "Oh no...", message: "You haven't to do list yet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true) {
                //
            }

        }
        
    }

    
    @objc func todowasChanged() {
        dataArray = glMainCD.getToDoList()
        todo_Collection?.reloadData()
    }
    
    func setButtonEditCollection () {
        
        edit_btn.setTitle(" edit list ", for: .normal)
        //edit_btn.setTitleColor(.black, for: .normal)
        edit_btn.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        edit_btn.sizeToFit()
        
        edit_btn.center.y   = (cTitle?.center.y)!
        edit_btn.frame.origin.x     = screen_width - edit_btn.frame.width - 20

        
        edit_btn.addTarget(self, action: #selector(editmode), for: .touchUpInside)
        
        view_btn.frame = edit_btn.frame
        view_btn.layer.cornerRadius = 10
        view_btn.backgroundColor = .lightGray
        view_btn.alpha = 0.5
       
        view.addSubview(view_btn)
        view.addSubview(edit_btn)
        
    }
    
    @objc func editmode () {
        if edditing_mode {
            edditing_mode = false
            view_btn.backgroundColor = .lightGray
            todo_Collection?.reloadData()
        } else {
            edditing_mode = true
            view_btn.backgroundColor = .red
            todo_Collection?.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
          if ((segue.identifier == "showObject") && (cur_uuid != nil)) {
            let vc = segue.destination as! detailObjVC
            vc.uuid = cur_uuid
         } else {
             fatalError()
         }
    }

}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension toDoVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
        cell.alpha = 0
        
        UICollectionViewCell.animate(withDuration: 2) {
            cell.alpha = 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let current_line = dataArray[indexPath.row]
        let cell = todo_Collection?.dequeueReusableCell(withReuseIdentifier: "toDoCell", for: indexPath) as! TodoCell
     
        cell.uuid = current_line.uuid
//        cell.backgroundColor = UIColor.lightGray
        
        let infoObj: InfoObject = glMainCD.getInfoByUUID(uuid: current_line.uuid!)
        
        
        let image_todo = UIImageView(frame: CGRect(x: 0, y: 0, width: screen_width/3, height: screen_width/3))
        image_todo.image = infoObj.image
        image_todo.contentMode = .scaleAspectFill
        image_todo.clipsToBounds = true
        cell.addSubview(image_todo)
        

            
            
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        label.text = infoObj.name
        label.font = UIFont(name: "HELVETICA", size: 11)
        label.sizeToFit()
        label.backgroundColor   = .white
        label.textColor         = .black
        label.frame = CGRect(x: 0, y: 0, width: (screen_width) / 3, height: label.frame.height)
        label.textAlignment = .center
        
        cell.addSubview(label)
        
        label.center = image_todo.center
        label.frame.origin.y = image_todo.frame.maxY - label.frame.height
        
        if edditing_mode {
            
            let edit = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
            edit.image = UIImage(named: "delete.png")
            edit.layer.cornerRadius = edit.frame.width/2
            cell.addSubview(edit)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let current_cell = todo_Collection?.cellForItem(at: indexPath) as! TodoCell
        cur_uuid = current_cell.uuid
        
        if !edditing_mode {
            performSegue(withIdentifier: "showObject", sender: self)
        }
        else {
            glMainCD.setToDo(uuid: cur_uuid!, delete: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil, userInfo: nil)
            Device.vibrate()
        }
    }
}


class TodoCell: UICollectionViewCell {
    var uuid: UUID?
}
