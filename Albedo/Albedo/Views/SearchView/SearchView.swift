import SwiftUI

struct SearchView: View {
    @ObservedObject var data = DataManager.shared
    @State var searchText : String = ""
    @State var showingFilterView = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
            Color(red: 0.958, green: 0.958, blue: 0.958).ignoresSafeArea()
            VStack {
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        LazyVStack{
                            HStack {}.frame(height: 20)
                            Group {
                                HStack {
                                    TextField("Suchen", text: $searchText)
                                        .font(.custom("DMSans-Regular", size: 18))
                                    Spacer()
                                    Button(action: {
                                        showingFilterView.toggle()
                                    }) {
                                        Image("filter")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 28)
                                    }.sheet(isPresented: $showingFilterView) {
                                        FilterView(isPresented: $showingFilterView)
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .background(Color(.white))
                                .cornerRadius(15)
                                .shadow(color: Color(red: 0, green: 0, blue: 0).opacity(0.07), radius: 15, y: 8)
                            }
                            .padding(.top)
                            .padding(.bottom)
                            .offset(y: 15)
                            HStack {
                                Text(data.searchResults.count.description + " Resultate")
                                    .font(.custom("DMSans-Regular", size: 15))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .padding(.leading, 6)
                                Spacer()
                            }
                            MapView(flats: $data.searchResults)
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
                                }
                                
                            }
                        }
                    }.background(Color(red: 0.958, green: 0.958, blue: 0.958))
                }.navigationBarHidden(true)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.top)
            }.padding(.leading).padding(.trailing)
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
