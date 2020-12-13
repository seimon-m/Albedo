import SwiftUI
import MapKit

struct SharedFlat: Identifiable {
    let id = UUID()
    let title: String
    let price: Int
    let place: CLLocationCoordinate2D
}

struct MapView: View {

    @Binding var coordRegion : MKCoordinateRegion
    @Binding var flats: [Flat]
    
    var body: some View {
        let flatsWithCoords = flats.filter{$0.coordinate != nil}
        Map(coordinateRegion: $coordRegion, annotationItems: flatsWithCoords){ flat in
            MapAnnotation(coordinate: flat.coordinate!, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                NavigationLink(destination: DetailView(flat: flat)) {
                    HStack(){
                        Text(flat.price.description + " CHF")
                            .padding(5)
                            .font(.system(size: 14.0))
                            
                    }
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 2, y: 1)
                }
            }
        }
        .cornerRadius(15)
    }
}
