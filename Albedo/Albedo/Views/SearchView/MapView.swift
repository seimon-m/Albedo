import SwiftUI
import MapKit

struct SharedFlat: Identifiable {
    let id = UUID()
    let title: String
    let price: Int
    let place: CLLocationCoordinate2D
}

struct MapView: View {
    //    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 47.051861, longitude: 8.304898) , span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    // Latitude: North/South (y)
    // Longitude: East/West (x)
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2DMake(47.051861, 8.304898), latitudinalMeters: 3000, longitudinalMeters: 3000)
    
    @State var flats: [Flat]
    
    var body: some View {
        let flatsWithCoords = flats.filter{$0.coordinate != nil}
        Map(coordinateRegion: $region, annotationItems: flatsWithCoords){ flat in
            MapAnnotation(coordinate: flat.coordinate!, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                HStack(){
                    Text(flat.price.description + " CHF")
                        .padding(5)
                        .font(.system(size: 14.0))
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2, y: 1)
            }
        }
        .cornerRadius(15)
    }
}

//struct MapView_Previews: PreviewProvider {
//    private var flats: [SharedFlat] = [
//        SharedFlat(title: "Hübsche WG", price: 510, place: CLLocationCoordinate2D(latitude: 47.047994, longitude: 8.300776)),
//        SharedFlat(title: "Schön gelegene Altstadt-WG", price: 630, place: CLLocationCoordinate2D(latitude: 47.060128, longitude: 8.307804)),
//    ]
//
//    static var previews: some View {
//        MapView()
//    }
//}
