
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        map.mapType = MKMapType.hybrid
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
        map.addAnnotation(rest)
        map.showsCompass = true
        map.showsScale = true
        map.showsTraffic = true
        map.isZoomEnabled = true
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
    
}
