
import UIKit
import MapKit

class mapVC: UIViewController {
    
    let screen_width    = UIScreen.main.bounds.width
    let screen_height   = UIScreen.main.bounds.height
    let glUsCoreData    = usCoreData()
    
    var map: MKMapView?
    var objs: [Sight]?
    var todo: [ToDo]?
    
    var currentSight: Sight?
    
    override func viewWillAppear(_ animated: Bool) {
        self.overrideUserInterfaceStyle = Device.getInterfaceMode()
    }
    
        
    fileprivate func setAnnotations() {
        for i in objs! {
            
            let sight_map = Sight_map(
                name: i.name!,
                crsight: i,
                lat: CLLocationDegrees(i.lati),
                long: CLLocationDegrees(i.long),
                pinimage: UIImage(named: i.imagename!) ?? UIImage(),
                thisToDo: glUsCoreData.checkItInToDo(uuid: i.uuid ?? UUID())
            )
            
            map?.addAnnotation(sight_map)
            
        }
    }
    
    override func viewDidLoad() {
        //MARK: viewDidLoad
        super.viewDidLoad()
        
        //MARK: GET OBJECTS
        objs = glUsCoreData.getMainScreenInfo()
        todo = glUsCoreData.getToDoList()
        
        
         //MARK: Set map
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: screen_width, height: screen_height))
        view.addSubview(map!)
        
        let cl_center = CLLocationCoordinate2D(latitude: 37.568561, longitude: 13.960773)
        map?.setRegion(MKCoordinateRegion(center: cl_center, latitudinalMeters: 10000*30, longitudinalMeters: 10000*30), animated: true)
    
        map?.delegate = self
        setAnnotations()
        
        let sicily_btn = UIButton(frame: CGRect(x: self.view.center.x, y: 45, width: 20, height: 20))
        //sicily_btn.setTitle("sicily", for: .normal)
        sicily_btn.setImage(UIImage(named: "map.png"), for: .normal)
        
        sicily_btn.sizeToFit()
        sicily_btn.alpha = 0
        sicily_btn.center.x = self.view.center.x
        sicily_btn.addTarget(self, action: #selector(sicilyInCenter), for: .touchUpInside)
        
        self.view.addSubview(sicily_btn)

        UIView.animate(withDuration: 2) {

           sicily_btn.alpha = 1
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(todochanged), name: NSNotification.Name(rawValue: "ToDoChanged"), object: nil)
        
        
    }
    
    @objc func sicilyInCenter() {
        
        Device.vibrate()
        
        let cl_center = CLLocationCoordinate2D(latitude: 37.568561, longitude: 13.960773)
        map?.setRegion(MKCoordinateRegion(center: cl_center, latitudinalMeters: 10000*30, longitudinalMeters: 10000*30), animated: true)
        
    }
    
    @objc func todochanged () {
        
        todo = glUsCoreData.getToDoList()
        
        for i in map!.annotations {
            map?.removeAnnotation(i)
        }

        setAnnotations()
        
    }
    
    
}


extension mapVC: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? Sight_map
            else {
                return nil
        }
        
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "sight_map")
        
        let obj_view = UIImageView()
        
    
        if (annotation.isToDo ?? false) {
            obj_view.layer.borderColor      = UIColor.yellow.cgColor
            obj_view.layer.borderWidth      = 2
            obj_view.frame                  = CGRect(x: 0, y: 0, width: 55, height: 55)
        } else {
            obj_view.layer.borderColor      = UIColor.gray.cgColor
            obj_view.layer.borderWidth      = 2
            obj_view.frame                  = CGRect(x: 0, y: 0, width: 45, height: 45)
        }
    
        obj_view.image = annotation.image
        
        obj_view.layer.cornerRadius     = obj_view.layer.frame.width / 2
        obj_view.layer.masksToBounds    = true
        obj_view.contentMode            = .scaleAspectFill

        
        view.layer.frame            = CGRect(x: 0, y: 0, width: 55, height: 55)
        view.contentMode            = .scaleAspectFill

        let label = UILabel(frame: CGRect(x: 0, y: 35, width: 55, height: 12))
        
        label.text              = annotation.title
        label.font              = UIFont(name: "Helvetica", size: 11)
        label.backgroundColor   = .white
        label.textColor         = .black
        label.sizeToFit()
       
        view.addSubview(obj_view)
        view.addSubview(label)

        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let sight_view = view.annotation as! Sight_map
        
        currentSight = sight_view.sight
        performSegue(withIdentifier: "showObject", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ((segue.identifier == "showObject") && (currentSight != nil)) {
            let vc = segue.destination as! detailObjVC
            vc.uuid = currentSight?.uuid
        } else {
            fatalError()
        }
    }
    
}

class Sight_map: NSObject, MKAnnotation {
    
    var identifier = "sight_map"
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var sight: Sight
    var isToDo: Bool?
    
    init(name:String, crsight: Sight, lat:CLLocationDegrees, long:CLLocationDegrees, pinimage: UIImage, thisToDo: Bool){
        
        title   = name
        coordinate = CLLocationCoordinate2DMake(lat, long)
        image   = pinimage
        sight   = crsight
        isToDo  = thisToDo
    }
}
