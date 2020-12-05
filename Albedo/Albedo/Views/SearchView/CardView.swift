//
//  CardView.swift
//  Albedo
//
//  Created by Jonas Wolter on 24.11.20.
//

import SwiftUI



struct CardView: View {
    let flat : Flat
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if(flat.hasImages){
                    let url = URL(string: flat.highResImageURLs[0])!
                    AsyncImage(url: url)
                        .frame(height: 200)
                        .clipped()
                }else{
                    Image("noPicturePlaceholder")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(String(flat.price)+".-")
                        .foregroundColor(Color(red: 0, green: 0.749, blue: 0.514))
                        .font(.custom("DMSans-Regular", size: 22))

                    Text(flat.title)
                        .font(.custom("DMSans-Medium", size: 28))
                        .foregroundColor(Color(.black))
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 14)
                        Text(flat.place)
                            .lineLimit(1)
                            .font(.custom("DMSans-Regular", size: 15))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }.padding(0)
                    HStack() {
                        HStack (){
                            Image("date")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 19)
                            Text(flat.startDate)
                                .font(.custom("DMSans-Bold", size: 16))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }.frame(width: 110, alignment: .topLeading)
                        HStack {
                            Image("termination")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text(flat.termination)
                                .lineLimit(1)
                                .font(.custom("DMSans-Bold", size: 16))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                    }.padding(.top, 12)
                }
                .padding()
                .padding(.top, -4)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(15)
        }

        
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFlat = Flat(url: "https://www.wgzimmer.ch/de/wgzimmer/search/mate/ch/luzern/1-1-2021--620-luzern.html", roomDescription: "Das Zimmer ist ca. 10m2 gross, sehr hell und gemütlich. Es verfügt über ein grosses Fenster. Die Wohnung befindet sich in einem kleinen Wohnblock im 3. Stock. Vom Balkon oder dem Wohnzimmer aus kann man einen schönen Blick auf den Pilatus und die Rigi geniessen. Das Wohnzimmer hat eine bequeme Sofaecke, die zu gemütlichen Abenden sowie lustigen als auch spannenden Gesprächen einlädt. Daneben befindet sich ein grosser Esstisch. Die Küche ist hell und sehr modern ausgestattet. Zudem gibt es zwei helle, neuwertige Badezimmer. Das grössere davon besitzt eine Badewanne und ein WC. Das kleinere verfügt über ein separates WC, was besonders am frühen Morgen für alle praktisch ist und sehr geschätzt wird. Zusätzlich hat es einen Fernseh- und Internetanschluss (für 20.- pro Monat auf die Miete) und Einbauschränke, welche gerne mitbenützt werden dürfen.", aboutUsDescription: "Sarah (24 Jahre) und Anita (23 Jahre). Wir sind beide berufstätig. Wir sind unkompliziert, offen und mögen interessante Gespräche. Sarah ist in den sonnigen Walliser Bergen aufgewachsen und seit etwas mehr als drei Jahren in Luzern. Wenn das Wetter stimmt, trifft man sie oft draussen in der Natur an. Anita kommt ursprünglich aus dem Berner Oberland. Sie tanzt gerne, liebt gute Musik und versucht ab und zu mit Leidenschaft neue Gerichte in der Küche aus. Wenn du denkst, dass du in unsere WG passen könntest, schreib uns doch in einer E-Mail einige Sätze über dich. Wir freuen uns, dich kennenzulernen! :)", aboutYouDescription: "Ein/e lebensfrohe/r, unkomplizierte/r und positive/r Mitbewohner/in in unserem Alter, welche/r sich gerne am WG-Leben beteiligt. Jede/r hat sein eigenes Leben, dennoch finden wir es schön und schätzen es beide, wenn man zuhause ist, dass man ab und zu gemeinsam etwas isst und dazu über alles Mögliche diskutieren kann. Dazu trinken wir auch gerne mal ein Bier oder einen guten Tropfen Wein. Einen gesunden Sinn für Sauberkeit ist uns wichtig, darum wäre es super, wenn du weisst, wie man den Putzlappen schwingt. ;)", street: "Kapfstrasse 33", zip: 6020, place: "Emmen", district: "Kapf", price: 620, startDate: "1.1.2021", termination: "Unbefristet", lowResImageURLs: ["https://img.wgzimmer.ch/.imaging/wgzimmer_medium-jpg/dam/3a28ebef-5b74-4864-8ab0-02e4a4c2b016/temp.jpg", "https://img.wgzimmer.ch/.imaging/wgzimmer_medium-jpg/dam/8d7ada4f-adec-4a1d-be86-74cb0482ee45/temp.jpg", "https://img.wgzimmer.ch/.imaging/wgzimmer_medium-jpg/dam/53284290-c292-4a3b-be04-ffb683861753/temp.jpg"], highResImageURLs: ["https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/3a28ebef-5b74-4864-8ab0-02e4a4c2b016/temp.jpg", "https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/8d7ada4f-adec-4a1d-be86-74cb0482ee45/temp.jpg", "https://img.wgzimmer.ch/.imaging/wgzimmer_shadowbox-jpg/dam/53284290-c292-4a3b-be04-ffb683861753/temp.jpg"])
        ZStack {
            Color(red: 0.958, green: 0.958, blue: 0.958)
                .ignoresSafeArea()
            CardView(flat: sampleFlat)
                .padding()
        }
    }
}
