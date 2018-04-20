import Foundation

import MathFramework




// for some reason, the error "Invalid redeclaraion of 'Aberration'" appears if I name the class
// Aberration instead of Aberratio
// the conflict seems to be in Ronchi -> Ronchi -> Ronchi.xcdatamodeld
// it uses core data, so for now stick with Aberratio and get Probe working with it, and switch to core data later

class Aberratio:NSObject {
    
    var n:Int = 0
    var m:Int = 0
    
    var label:NSString = "Unspecified"
    
    var aberrDict:NSMutableDictionary = [String: Aberratio]() as! NSMutableDictionary
    // key is C_01, C_10, etc/A_0, B_2, etc
    //      aka krivanekLabel/haiderLabel
    // value is Aberratio for a given aberration
    
    let Cnma:NSNumber
    let Cnmb:NSNumber
    
    var max:Float = 10000
    var min:Float = -10000
    
    var symRange:Bool = true
    
    var mag:NSNumber
    var angle:NSNumber
    
    //let haiderLabel:NSAttributedString
    // commented out for now
    let krivanekLabel:NSAttributedString
    
    // initialization of n, m, Cnma, and Cnmb
    // angle, mag, and krivanekLabel are also calculated
    
    init(_ nVal:Int, _ mVal:Int, _ CnmaVal:Float, _ CnmbVal:Float) {
        
        self.n = nVal
        self.m = mVal
        
        let nCnma = NSNumber(value: CnmaVal)
        let nCnmb = NSNumber(value: CnmbVal)
        
        self.Cnma = nCnma
        self.Cnmb = nCnmb
        
        let fcnma = Cnma.floatValue
        let fcnmb = Cnmb.floatValue
        
        self.mag = NSNumber(value: sqrtf(fcnma*fcnma + fcnmb*fcnmb))
        
        if fcnma == Float(0) {
            
            self.angle = NSNumber(value: Float(0))
            
        } else {
            
            self.angle = NSNumber(value: atanf(fcnmb/fcnma*180/Float.pi))
        }
        
        krivanekLabel = NSAttributedString(string: "C\(n)\(m)")
        
    }
    
    
    // sets new max and min
    
    func setBounds(_ newMin:Float, _ newMax:Float) -> () {
        
        self.min = newMin
        self.max = newMax
        
    }
    
    
    // returns the dictionary of aberrations
    
    func coefficients() -> NSMutableDictionary {
        
        return aberrDict
        
    }
    
    
    // returns abberation object in aberrDict given its key
    
    func aberrationForKey (_ key:String) -> Aberratio {
        
        return aberrDict.value(forKey:key) as! Aberratio
        
    }
    
    
}




