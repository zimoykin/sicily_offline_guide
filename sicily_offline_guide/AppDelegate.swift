//
//  AppDelegate.swift
//  sicily_offline_guide
//
//  Created by Дмитрий on 08.12.2019.
//  Copyright © 2019 DZ. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let context = self.persistentContainer.viewContext
        
        do {
            let dtbase = try context.fetch(Sight.fetchRequest()) as [Sight]
            if dtbase.count < 6 {
                print("dt base is empty")
               //we will make a new base from file
                makeNewDT()
            }
            
        }
        catch let error as NSError {
            print("mistake! + \(error), \(error.userInfo)")
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func makeNewDT () {
        
        // MARK: remove all
        let context = self.persistentContainer.viewContext
        
        do {
            let dtbase_sight = try context.fetch(Sight.fetchRequest()) as [Sight]
            
            for i in dtbase_sight {
                context.delete(i)
            }
            
            let dtbase_todo = try context.fetch(ToDo.fetchRequest()) as [ToDo]
            
            for i in dtbase_todo {
                context.delete(i)
            }
            
        } catch let error as NSError {
            print("mistake! + \(error), \(error.userInfo)")
        }
        

        // MARK: add new
        createNewItem(name: "Val di noto",
                      lati: 36.979038, long: 14.985618,
                      fulldescription: "The oldest recorded settlement in the Val di Noto was the ancient town of Akrai, near Palazzolo Acreide, which was founded in 664 BC. It was the first colony of the Corinthian settlement at Syracuse.\n The settlements of the Val di Noto were completely destroyed by the enormous 1693 Sicily earthquake. Following the earthquake, many towns were rebuilt on entirely new sites, such as Noto and Grammichele. The rulers of the time, the kings of Spain, granted the nobleman Giuseppe Lanza special authority to redesign the damaged towns, which he achieved by sympathetically designing the new towns in a baroque and renaissance style.\nThe new settlements were redesigned to have a town square in the centre and to spread out in a radial pattern from there. Major buildings like churches, cloisters and palaces were built as focal points for the new streets, and the streets themselves were laid out in a grid pattern. Many of the individual towns were rebuilt to have a unique character, such as the town of Grammichele which was built in a hexagonal shape with the town square in the centre, consisting of the parish and town hall.\nThe towns were rebuilt in what came to be known as the Sicilian Baroque style; the most notable of which is the town of Noto itself, which is now a popular tourist destination due to its fine Baroque architecture.",
                      unesco: true,
                      rang: 5,
                      imageName: "valdinoto.jpg",
                      context: context)
        
        createNewItem(name: "Reserva Naturale Zingaro",
                      lati: 38.124765, long: 12.788857,
                      fulldescription: "Riserva naturale dello zingaro was the first natural reserve set up in Sicily in May 1981,[1] located almost completely in the municipal territory of San Vito Lo Capo. It stretches along some seven kilometers of unspoilt coastline of the Gulf of Castellammare and its mountain chain, the setting of steep cliffs and little bays. \n The Zingaro Reserve has a large variety and abundance of rare and endemic plants it also has a rich fauna. The highly varied ecological niches give a great diversity which is not easily found in others parts of the island. In the Zingaro Reserve at least 39 species of birds nest and mate, mainly birds of prey, including the peregrine falcon, the common kestrel and the common buzzard. The area has also a rich archaeological past; for example the spectacular Grotta dell'Uzzo [it] was one of the first prehistoric settlements in Sicily. The reserve has a complex network of paths, shelters, water taps, picnic areas, museums, carpark, and other amenities; there are no roads and it can only be visited on foot.[2]\nThe Zingaro Reserve does not only include the land, but also the sea and beaches, which stretch along the coast for almost 7 km. The beautiful beaches, pebbled and lapped by the clear blue sea, can be reached along various rather steep paths.",
                      unesco: false,
                      rang: 6,
                      imageName: "zingaro.jpg",
                      context: context)
        createNewItem(name: "Valleys of the Temples",
                      lati: 37.316666, long: 13.583333,
                      fulldescription: "Valley of the Temples is an archaeological site in Agrigento (ancient Greek Akragas), Sicily. It is one of the most outstanding examples of Greater Greece art and architecture, and is one of the main attractions of Sicily as]] list in 1997. Much of the excavation and restoration of the temples was due to the efforts of archaeologist Domenico Antonio Lo Faso Pietrasanta (1783–1863), who was the Duke of Serradifalco from 1809 through 1812.",
                      unesco: true,
                      rang: 4,
                      imageName: "valledeitempli.jpg",
                      context: context)
        createNewItem(name: "Scala dei Turchi",
                      //37.289915, 13.472816
                      lati: 37.289915, long: 13.472816,
                      fulldescription: "The Scala dei Turchi (Italian: 'Stair of the Turks') is a rocky cliff on the coast of Realmonte, near Porto Empedocle, southern Sicily, Italy. It has become a tourist attraction, partly due to its mention in Andrea Camilleri's series of detective stories about Commissario Montalbano.\n The Scala is formed by marl, a sedimentary rock with a characteristic white color. It lies between two sandy beaches, and is accessed through a limestone rock formation in the shape of a staircase, hence the name. The latter part of the name derives from the frequent raids carried on by Moors. \n In August 2007, the municipality of Realmonte applied for the inclusion of the Scala dei Turchi (together with the nearby Roman Villa Aurea) in the UNESCO Heritage List.",
                      unesco: false,
                      rang: 3,
                      imageName: "scaladeiturchi.jpg",
                      context: context)
        createNewItem(name: "Greek Theatre of Taormina",
                      lati: 37.852293, long: 15.292208,
                      fulldescription: "The ancient theatre (the teatro greco, or 'Greek theatre') is built for the most part of brick, and is therefore probably of Roman date, though the plan and arrangement are in accordance with those of Greek, rather than Roman, theatres; whence it is supposed that the present structure was rebuilt upon the foundations of an older theatre of the Greek period. With a diameter of 120 metres (390 ft) (after an expansion in the 2nd century), this theatre is the second largest of its kind in Sicily (after that of Syracuse); it is frequently used for operatic and theatrical performances and for concerts. The greater part of the original seats have disappeared, but the wall which surrounded the whole cavea is preserved, and the proscenium with the back wall of the scena and its appendages, of which only traces remain in most ancient theatres, are here preserved in singular integrity, and contribute much to the picturesque effect, as well as to the interest, of the ruin. From the fragments of architectural decorations still extant we learn that it was of the Corinthian order, and richly ornamented. Some portions of a temple are also visible, converted into the church of San Pancrazio, but the edifice is of small size.",
                      unesco: true,
                      rang: 2,
                      imageName: "greekTaormina.jpg",
                      context: context)
        createNewItem(name: "Etna",
                      lati: 37.751054, long: 14.993432,
                      fulldescription: "Mount Etna, or Etna (Italian: Etna [ˈɛtna] or Mongibello [mondʒiˈbɛllo]; Sicilian: Mungibeddu [mʊndʒɪbˈbɛɖɖʊ] or â Muntagna; Latin: Aetna; Greek: Αίτνα), is an active stratovolcano on the east coast of Sicily, Italy, in the Metropolitan City of Catania, between the cities of Messina and Catania. It lies above the convergent plate margin between the African Plate and the Eurasian Plate. It is the highest active volcano in Europe outside the Caucasus[3] and the highest peak in Italy south of the Alps with a current hight of 3,326 m (10,912 ft), though this varies with summit eruptions. Etna covers an area of 1,190 km2 (459 sq mi) with a basal circumference of 140 km (87 miles). This makes it by far the largest of the three active volcanoes in Italy, being about two and a half times the height of the next largest, Mount Vesuvius. Only Mount Teide on Tenerife in the Canary Islands surpasses it in the whole of the European–North-African region west of the Black Sea.[4] In Greek Mythology, the deadly monster Typhon was trapped under this mountain by Zeus, the god of the sky and thunder and king of gods, and the forges of Hephaestus were said also to be underneath it.\n Mount Etna is one of the world's most active volcanoes and is in an almost constant state of activity. The fertile volcanic soils support extensive agriculture, with vineyards and orchards spread across the lower slopes of the mountain and the broad Plain of Catania to the south. Due to its history of recent activity and nearby population, Mount Etna has been designated a Decade Volcano by the United Nations.[6] In June 2013, it was added to the list of UNESCO World Heritage Sites.",
                      unesco: false,
                      rang: 1,
                      imageName: "etna.jpg",
                      context: context)

        //enna 37.557023, 14.256488
        
        do {
           try context.save()
        } catch let error as NSError {
            print("some troubles... \(error), \(error)")
        }
        
        
        
    }
    
    func createNewItem (name: String, lati: Float, long: Float, fulldescription: String, unesco: Bool, rang: Int16, imageName: String, context: Any) {
        
        let new_sight = Sight(entity: Sight.entity(), insertInto: context as? NSManagedObjectContext)
        
        new_sight.name = name
        new_sight.fulldescription = fulldescription
        
        new_sight.unesco = unesco
        new_sight.rang = rang
        
        new_sight.imagename = imageName
        
        //location
        new_sight.lati = lati
        new_sight.long = long
        
        new_sight.uuid = UUID()
        
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "sicily_offline_guide")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

