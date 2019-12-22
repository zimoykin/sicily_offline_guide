
//import Foundation
import CoreData
import UIKit


struct InfoObject {
    var image: UIImage
    var name: String
}


class usCoreData {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getMainScreenInfo ()  -> [Sight]{
        
        var mainInfo = [Sight] ()
        
        let fetchRequest:NSFetchRequest<Sight> = Sight.fetchRequest()
        let rangSort = NSSortDescriptor(key:"rang", ascending: true)
        fetchRequest.sortDescriptors = [rangSort]
        
        do {
            
            mainInfo = try context.fetch(fetchRequest)
            
        }
        catch let error as NSError {
            print("mistake! + \(error), \(error.userInfo)")
        }
        
        return mainInfo
        
    }
    
    
    func getObjByUUID (uuid: UUID) -> Sight? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sight")
        request.predicate = NSPredicate(format: "uuid == %@", argumentArray: [uuid])
        
        do {
            if let result = try! context.fetch(request) as? [Sight] {
                return result.first!
            }
        }
        
        return nil
    }
    
//    MARK: TODO
    
    func getToDoList () -> [ToDo] {
        
        var mainInfo = [ToDo] ()
        
        do {
            mainInfo = try context.fetch(ToDo.fetchRequest()) as! [ToDo]
        }
        catch let error as NSError {
            print("mistake! + \(error), \(error.userInfo)")
        }
        
        return mainInfo
        
    }
        
    //    MARK: Is in todo
    func checkItInToDo (uuid: UUID) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        request.predicate = NSPredicate(format: "uuid == %@", argumentArray: [uuid])
        
        do {
            if let result = try! context.fetch(request) as? [ToDo] {
                if result.count > 0 {
                    return true
                }
                else {
                    return false
                }
            }
        }
        
        return false
        
    }
    
    
    func setToDo (uuid: UUID, delete: Bool) {
        
        //        remove
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        request.predicate = NSPredicate(format: "uuid == %@", argumentArray: [uuid])
        
        do {
            if let result = try! context.fetch(request) as? [ToDo] {
                for i in result {
                    context.delete(i)
                }
            }
        }
        
        
        if delete {
            
            do {
                try context.save()
            } catch let error as NSError {
                print("a problem with set to do... \(error), \(error)")
            }
            
            return
        }
        
        // else add in todo list
        
        let todo = ToDo(entity: ToDo.entity(), insertInto: context)
        todo.uuid = uuid
        todo.date = Date()
        
        do {
            try context.save()
        } catch let error as NSError {
            print("a problem with set to do... \(error), \(error)")
        }
        
    }
    
//    MARK: get Image UUID
    func getInfoByUUID (uuid: UUID) -> InfoObject {
        
        var image_name = "nophoto.png"
        var object_name = ""
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sight")
        
        request.predicate = NSPredicate(format: "uuid == %@", argumentArray: [uuid])
        
        do {
            if let result = try! context.fetch(request) as? [Sight] {
                for i in result {
                    image_name  = i.imagename!
                    object_name = i.name!
                    break
                }
            }
        }
        
        
        return InfoObject(image: UIImage(named: image_name)!, name: object_name)
        
    }
    
    
}
