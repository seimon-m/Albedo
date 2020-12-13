import SwiftUI
import MapKit

struct SearchView: View {
    @ObservedObject var data = DataManager.shared
    @ObservedObject var favorites = Favorites.shared
    @State var region : Region? = Regions.defaultRegion
    @State var currentCoordRegion : MKCoordinateRegion?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
                Color(red: 0.958, green: 0.958, blue: 0.958).ignoresSafeArea()
                VStack {
                    HStack {}.frame(height: 60)
                    ScrollView(showsIndicators: false) {
                        LazyVStack{
                            HStack {}.frame(height: 54)
                            HStack {
                                Text(data.searchResults.count.description + " Resultate")
                                    .font(.custom("DMSans-Regular", size: 15))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .padding(.leading, 6)
                                Spacer()
                            }
                            MapView(coordRegion: .init(
                                        get: {region?.coordRegion ?? Regions.defaultRegion.coordRegion },
                                        set: {region?.coordRegion = $0}),
                                    flats: $data.searchResults)
                                .frame(height: 300)
                                .padding(.bottom)
                            HStack {
                                Text("Finde deine WG")
                                    .font(.custom("DMSans-Bold", size: 28))
                                    .foregroundColor(Color(.black))
                                Spacer()
                            }
                            ForEach(data.searchResults){ flat in
                                NavigationLink(destination: DetailView(flat: flat)) {
                                    CardView(flat: flat)
                                        .padding(.bottom)
                                }
                            }
                        }
                    }.background(Color(red: 0.958, green: 0.958, blue: 0.958))
                }.navigationBarHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.top)
                .padding(.leading)
                .padding(.trailing)
                
                SearchBar(region: self.$region)
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            }
            .navigationBarTitle("Suche", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


