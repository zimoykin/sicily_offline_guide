

import UIKit

class toDoVC: UIViewController {
    
    let glMainCD = usCoreData()
    
    var cTitle: UITextView?
    
    var dataArray:          Array <ToDo> = []
    let screen_width:       CGFloat = UIScreen.main.bounds.width
    let screen_height:      CGFloat = UIScreen.main.bounds.height
    var todo_Collection:    UICollectionView?
    
    var cur_uuid: UUID?
    
    
//    MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: (screen_width-20) / 3, height: (screen_width-20) / 3)
        collectionViewLayout.minimumLineSpacing = 10

        todo_Collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height), collectionViewLayout: collectionViewLayout)
            
        todo_Collection!.backgroundColor = .white
        todo_Collection?.register(TodoCell.self, forCellWithReuseIdentifier: "toDoCell")
        
        todo_Collection!.delegate    = self
        todo_Collection!.dataSource  = self
        
        dataArray = glMainCD.getToDoList()
        
        todo_Collection?.reloadData()
        
        view.addSubview(todo_Collection!)
        
        cTitle = UITextView(frame: CGRect(x: 0, y: 0, width: screen_width, height: 20))
        cTitle?.text = "Things you must do in sicily!"
        cTitle?.sizeToFit()
        cTitle?.center = view.center
        cTitle?.textColor = .black
        cTitle?.backgroundColor = .white
        
        cTitle?.alpha = 0.1
        
        view.addSubview(cTitle!)
        
        
        UIView.animate(withDuration: 1) {
            self.cTitle?.frame.origin.y = (self.todo_Collection?.frame.origin.y)! + 40
            self.todo_Collection?.frame.origin.y = (self.todo_Collection?.frame.origin.y)! +  (self.cTitle?.frame.height)! + 40
            
        }
        
        UIView.animate(withDuration: 1) {
            self.cTitle?.frame = CGRect(x:  0, y:  (self.cTitle?.frame.origin.y)!, width: self.screen_width, height:  (self.cTitle?.frame.height)!)
            self.cTitle?.alpha = 1
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(todowasChanged), name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @objc func todowasChanged() {
        dataArray = glMainCD.getToDoList()
        todo_Collection?.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let current_line = dataArray[indexPath.row]
        let cell = todo_Collection?.dequeueReusableCell(withReuseIdentifier: "toDoCell", for: indexPath) as! TodoCell
     
        cell.uuid = current_line.uuid
        cell.backgroundColor = UIColor.lightGray
        
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
        
        cell.addSubview(label)
        
        label.center = image_todo.center
        label.frame.origin.y = image_todo.frame.maxY - label.frame.height
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let current_cell = todo_Collection?.cellForItem(at: indexPath) as! TodoCell
        
        cur_uuid = current_cell.uuid
        performSegue(withIdentifier: "showObject", sender: self)
        
    }
    
    
}


class TodoCell: UICollectionViewCell {
 
    var uuid: UUID?
    
}
