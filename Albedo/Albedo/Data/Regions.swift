//
//  Regions.swift
//  Albedo
//
//  Created by Jonas Wolter on 06.12.20.
//

import Foundation
import MapKit

class Regions{
    
    public static var defaultRegion = Region(searchStrings: ["luzern", "sursee"], queryKey: "luzern", centerCoordinate: CLLocationCoordinate2DMake(47.050167, 8.309307), areaSize: 6000)
    
    // Koordinaten z.B. über diese Webseite bestimmen https://www.latlong.net/
    private static let regions : [Region] =
        [Region(searchStrings: ["luzern", "sursee"], queryKey: "luzern", centerCoordinate: CLLocationCoordinate2DMake(47.050167, 8.309307), areaSize: 6000),
         Region(searchStrings: ["schaffhausen"], queryKey: "schaffhausen", centerCoordinate: CLLocationCoordinate2DMake(47.696785,8.633417), areaSize: 6000),
         Region(searchStrings: ["aargau"], queryKey: "aargau", centerCoordinate: CLLocationCoordinate2DMake(47.379238,8.084340), areaSize: 6000),
         Region(searchStrings: ["aarau"], queryKey: "aarau", centerCoordinate: CLLocationCoordinate2DMake(47.390434,8.045701), areaSize: 6000),
         Region(searchStrings: ["appenzell", "innerrhoden"], queryKey: "appenzell-innerrhoden", centerCoordinate: CLLocationCoordinate2DMake(47.307880,9.403310), areaSize: 6000),
         Region(searchStrings: ["appenzell", "ausserrhoden"], queryKey: "appenzell-ausser", centerCoordinate: CLLocationCoordinate2DMake(47.307880,9.403310), areaSize: 6000),
         Region(searchStrings: ["baden"], queryKey: "baden", centerCoordinate: CLLocationCoordinate2DMake(47.474380,8.306920), areaSize: 6000),
         Region(searchStrings: ["basel"], queryKey: "baselstadt", centerCoordinate: CLLocationCoordinate2DMake(47.559601,7.588576), areaSize: 6000),
         Region(searchStrings: ["bern", "bärn"], queryKey: "bern", centerCoordinate: CLLocationCoordinate2DMake(46.949436, 7.438715), areaSize: 6000),
         Region(searchStrings: ["biel"], queryKey: "biel", centerCoordinate: CLLocationCoordinate2DMake(47.143299,7.248760), areaSize: 6000),
         Region(searchStrings: ["chur"], queryKey: "chur", centerCoordinate: CLLocationCoordinate2DMake(46.849491,9.530670), areaSize: 6000),
         Region(searchStrings: ["fribourg", "freiburg"], queryKey: "fribourg", centerCoordinate: CLLocationCoordinate2DMake(46.806477,7.161972), areaSize: 6000),
         Region(searchStrings: ["genf"], queryKey: "genf", centerCoordinate: CLLocationCoordinate2DMake(46.204391,6.143158), areaSize: 6000),
         Region(searchStrings: ["olten"], queryKey: "olten", centerCoordinate: CLLocationCoordinate2DMake(47.349962,7.903703), areaSize: 6000),
         Region(searchStrings: ["st-gallen", "st. gallen", "st.gallen", "sankt gallen", "sanktgallen"], queryKey: "st-gallen", centerCoordinate: CLLocationCoordinate2DMake(47.4234,9.3696), areaSize: 6000),
         Region(searchStrings: ["zurich-stadt", "zurich", "zürich", "züri"], queryKey: "zurich-stadt", centerCoordinate: CLLocationCoordinate2DMake(47.376887,8.541694), areaSize: 6000),
         Region(searchStrings: ["winterthur", "winti"], queryKey: "winterthur", centerCoordinate: CLLocationCoordinate2DMake(47.503847,8.726249), areaSize: 6000),
         Region(searchStrings: ["lausanne"], queryKey: "lausanne", centerCoordinate: CLLocationCoordinate2DMake(46.519654,6.632273), areaSize: 6000)]
    
    static func getRegion(searchString: String) -> Region? {
        let str = searchString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        for region in regions {
            if region.searchStrings.contains(str) { return region}
        }
        return nil
    }
    private init(){}
}


struct Region {
    internal init(searchStrings: [String], queryKey: String, centerCoordinate: CLLocationCoordinate2D, areaSize: Double) {
        self.searchStrings = searchStrings
        self.queryKey = queryKey
        self.centerCoordinate = centerCoordinate
        self.areaSize = areaSize
        self.coordRegion = MKCoordinateRegion(center: self.centerCoordinate,
                                              latitudinalMeters: self.areaSize, longitudinalMeters: self.areaSize)
    }
    
    let searchStrings : [String]
    let queryKey : String
    let centerCoordinate : CLLocationCoordinate2D // Mittelpunkt von Übersichtskarte eines Ortes
    let areaSize : Double // Breite der Karte in Metern wieviel Gebiet rundherum Mittelpunkt herum angezeigt wird
    var coordRegion : MKCoordinateRegion
}
