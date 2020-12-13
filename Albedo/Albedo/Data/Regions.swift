//
//  Regions.swift
//  Albedo
//
//  Created by Jonas Wolter on 06.12.20.
//

import Foundation
import MapKit

class Regions{
    
    static let shared = Regions()
    
    // Koordinaten z.B. über diese Webseite bestimmen https://www.latlong.net/
    private let regions : [Region] =
        [Region(searchStrings: ["luzern", "sursee"], queryKey: "luzern", centerCoordinate: CLLocationCoordinate2DMake(47.050167, 8.309307), areaSize: 4000),
         Region(searchStrings: ["schaffhausen"], queryKey: "schaffhausen", centerCoordinate: CLLocationCoordinate2DMake(47.696785,8.633417), areaSize: 4000)]
    
    func getRegion(searchString: String) -> Region? {
        let str = searchString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        for region in regions {
            if region.searchStrings.contains(str) { return region}
        }
        return nil
    }
    private init(){}
}


struct Region {
    let searchStrings : [String]
    let queryKey : String
    let centerCoordinate : CLLocationCoordinate2D // Mittelpunkt von Übersichtskarte eines Ortes
    let areaSize : Double // Breite der Karte in Metern wieviel Gebiet rundherum Mittelpunkt herum angezeigt wird
    
    func getCoordRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: self.centerCoordinate,
                                  latitudinalMeters: self.areaSize, longitudinalMeters: self.areaSize)
    }
}
