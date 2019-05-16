
import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    private let locationManager = CLLocationManager()
    var matchingItems:[MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    var receivedAppliance = "Refrigerador"
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        map.mapType = MKMapType.hybrid
        map.reloadInputViews()
        let cl = CLLocationCoordinate2DMake(19.2853955, -99.1377706)
        map.region = MKCoordinateRegion(center: cl, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        // Para hacer un mapa a traves de un span
        /*
         let delta = CLLocationDegrees(0.01)
         let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
         map.region = MKCoordinateRegion(center: cl, span: span)
         */
        
        let rest = MKPointAnnotation()
        rest.coordinate = cl
        rest.title = "Comprar Dispositivo"
        rest.subtitle = ""
        //map.addAnnotation(rest)
        map.showsCompass = true
        map.showsScale = true
        map.showsTraffic = true
        map.isZoomEnabled = true
        var request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Home Depot"
        request.region = map.region
        var search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            if self.matchingItems.count > 0 {
                var selectedItem = self.matchingItems[0].placemark
                self.dropPinZoomIn(placemark: selectedItem)
            }
            
            if self.matchingItems.count > 1 {
                var selectedItem = self.matchingItems[1].placemark
                self.dropPinZoomIn(placemark: selectedItem)
            }
            if self.matchingItems.count > 2 {
                var selectedItem = self.matchingItems[2].placemark
                self.dropPinZoomIn(placemark: selectedItem)
            }
        }
        
        request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Costco"
        request.region = map.region
        search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            if self.matchingItems.count > 0 {
                var selectedItem = self.matchingItems[0].placemark
                self.dropPinZoomIn(placemark: selectedItem)
            }
            
            if self.matchingItems.count > 1 {
                var selectedItem = self.matchingItems[1].placemark
                self.dropPinZoomIn(placemark: selectedItem)
            }
            if self.matchingItems.count > 2 {
                var selectedItem = self.matchingItems[2].placemark
                self.dropPinZoomIn(placemark: selectedItem)
            }
        }
        
        request = MKLocalSearch.Request()
        if receivedAppliance != "" {
            request.naturalLanguageQuery = receivedAppliance
            request.region = map.region
            search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                print("ENTERED QUERY")
                print("RESULTS")
                print(response.mapItems)
                if self.matchingItems.count > 0 {
                    var selectedItem = self.matchingItems[0].placemark
                    self.dropPinZoomIn(placemark: selectedItem)
                }
                
                if self.matchingItems.count > 1 {
                    var selectedItem = self.matchingItems[1].placemark
                    self.dropPinZoomIn(placemark: selectedItem)
                }
            }
        }
       
       
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            map.showsUserLocation = false
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            map.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        print("MAPKIT CALLED")
        let v = view.annotation as? MKPointAnnotation
        openMapForPlace(view:view, latitude: (v?.coordinate.latitude)!, longitude: (v?.coordinate.longitude)!)
    }
    
    func openMapForPlace(view:MKAnnotationView,latitude:CLLocationDegrees,longitude:CLLocationDegrees) {
        let regionDistance:CLLocationDistance = 2000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = (view.annotation?.title)!
        mapItem.openInMaps(launchOptions: options)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = map,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
        }
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

}


extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        //map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        var titleString:String = placemark.description
        var splittedText = titleString.components(separatedBy: ",")
        if splittedText.count > 1 {
            annotation.title = splittedText[0] + ", " + splittedText[1]
        }
        else {
            annotation.title = placemark.title

        }
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = city
        }
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        map.setRegion(region, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.removeAnnotations(map.annotations)
    }
}
