//
//  Geocoder.swift
//  Albedo
//
//  Created by Jonas Wolter on 08.12.20.
//

import Foundation
import CoreLocation

class Geocoder{
    
    var flats : [Flat]
    
    var geocodingTimer : Timer?
    
    private let geocodingInterval : Double // in Seconds
    static let GEOCODING_BATCH_SIZE = 50
    
    
    init(flats : inout [Flat], geocodingInterval : Double = 5.1){
        self.flats = flats
        self.geocodingInterval = geocodingInterval
    }
    
    func startGeocoding(){
        stopGeocoding()
        geocodeBatch()
        geocodingTimer = Timer.scheduledTimer(timeInterval: self.geocodingInterval, target: self, selector: #selector(geocodeBatch), userInfo: nil, repeats: true)
    }
    
    func stopGeocoding(){
        geocodingTimer?.invalidate();
    }
    
    // Geocodes one Batch of 50 Adresses (50 is the maximum per minute)
    @objc func geocodeBatch(){
        DispatchQueue.global(qos: .utility).async {
            
            print("Flats count: " + self.flats.count.description )
            
            let missingCoords = self.flats.filter{$0.coordinate == nil}
            print("Coords missing: " + missingCoords.count.description)
                    
            
            var requestsCount = 0
            for i in 0..<self.flats.count{
                let flat = self.flats[i]
                
                // Break if already sent 50 requests
                if(requestsCount >= Geocoder.GEOCODING_BATCH_SIZE) { break }
                // Go to next if flat already has coordinate
                if(flat.coordinate != nil) { continue }
                
                // Start request
                requestsCount += 1
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(flat.adress) { [weak self] (placemarks, error) in
                    guard let coord : CLLocationCoordinate2D = placemarks?.first?.location?.coordinate else{
                        // return if no coordinate found
                        return
                    }
                    print("found coordinate")
                    // Wird automatisch auf Main Thread ausgeführt...
                    self?.flats[i].coordinate = coord
                }
            }
            
            if(requestsCount == 0){
                self.stopGeocoding()
            }
        }
    }
    
}
