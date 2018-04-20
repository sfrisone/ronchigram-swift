

import Foundation
import MathFramework


class Probe: NSObject {
    
    //setting default values for some things and initializing the other variables
    var rows:Int
    var columns:Int
    var waveSize:Int = 256
    var realSize:Float = 74.0
    var lambda:Float = 0.0197
    var apertureSize:Float = 10.0
    var waveFunction:Matrix
    var aperture:Matrix
    var setAberrations = [Aberratio]()
    var fft:FFTController
    
    //assigning values to waveFunction, aperture
    override init() {
        
        rows = waveSize
        columns = waveSize
        
        waveFunction = Matrix(waveSize, waveSize, "complex")
        aperture = Matrix(waveSize, waveSize, "complex")
        fft = FFTController()
        //obj-c code: fftController = [[SAFFTController alloc] initWithInput:aperture Output:wavefunction];
    }
    
    //trying to initialize so that Probe(Int, Int) gives the probe a number of rows and columns
    init (_ numberRows:Int, _ numberColumns:Int) {
        
        rows = waveSize
        columns = waveSize
        self.rows = numberRows
        self.columns = numberColumns
        
        self.waveFunction = Matrix(waveSize, waveSize, "complex")
        self.aperture = Matrix(waveSize, waveSize, "complex")
        
        self.fft = FFTController()
    }
    
    //applying aberrations to a probe
    func probeWithAberration (_ newAberrations:Array<Aberratio>, _ realSize:Float, _ apertureSize:Float, _ wavelength:Float, _ pixels:NSSize) -> (Probe) {
        
        let newProbe = Probe(Int(pixels.height), Int(pixels.width))
        
        newProbe.realSize = realSize
        newProbe.apertureSize = apertureSize
        newProbe.lambda = wavelength
        newProbe.setAberrations = newAberrations
        
        return newProbe
    }
    
    //calculates probe using chi
    //two modes: regular and fastCalc, which computes every other row and averages them
    //fastCalc to be written later
    func calculateProbe() -> () {
        
        //var fastCalc:Bool
        //add fastCalc later
        
        var k = Array(repeating: Float(0), count:2)
        var kMag:Float
        
        var chi1:Float
        var chi2:Float
        //maybe used in fastCalc?
        var chi:Float
        var chiExp:Complex
        
        //[aperture zeroMatrixComplex]
        //does this set aperture to all zeroes?
        self.waveFunction.real = Array(repeating: Float(0), count: self.waveSize*self.waveSize)
        self.waveFunction.imag = Array(repeating: Float(0), count: self.waveSize*self.waveSize)
        
        let maxK = (self.apertureSize*1E-3)/self.lambda
        let maxK2 = powf(maxK, 2)
        
        let iMid = Int(ceilf((Float(self.waveSize)/2.0)))
        let jMid = Int(ceilf((Float(self.waveSize)/2.0)))
        
        let numXpix:Int = Int(round(maxK/(1/realSize)))
        let numYpix:Int = Int(round(maxK/(1/realSize)))
        
        var n:Float
        var m:Float
        var Cnma:Float
        var Cnmb:Float
        
        //var lk0mlk1:Float
        var lk0mlk1:Complex
        var input:Float
        var skip:Int = 1
        //keep as var so when add fastCalc it works
        
        /*
         if fastCalc == true {
         skip = 2
         }
         */
        
        let iStart = iMid - numYpix
        let jStart = jMid - numXpix
        
        for i in iStart..<iMid + numYpix {
            for j in jStart..<jMid + numXpix {
                
                k[1] = (1.0/realSize) * Float(iMid - i)
                k[0] = (1.0/realSize) * Float(j - jMid)
                
                kMag = (k[0])*(k[0])+(k[1])*(k[1])
                
                if kMag <= maxK2 {
                    
                    chi1 = 0
                    chi2 = 0
                    chi = 0
                    
                    // calculates chi for each aberration at each point i,j
                    for aberration in self.setAberrations {
                        
                        n = Float(aberration.n)
                        m = Float(aberration.m)
                        Cnma = (aberration.Cnma.floatValue)*Float(10000)
                        Cnmb = (aberration.Cnmb.floatValue)*Float(10000)
                        
                        lk0mlk1 = cpow(Complex(self.lambda*k[0], -self.lambda*k[1]), Int(m))
                        //chi = creal(Complex(Cnma*lk0mlk1, Cnmb*lk0mlk1)) * powf((k[0]*k[0]*probe.lambda*probe.lambda + k[1]*k[1]*probe.lambda*probe.lambda), (((n - m + 1)/2)/(n + 1 + chi)))
                        // if creal just gives the real portion of a complex number, why use it at all? just use Cnma*lk0mlk1 instead
                        // need to do calc'n in complex numbers and then get the real portion of that
                        // creal(...) is real portion of [Cnma*lk0mlk1 + i(Cnmb*lk0mlk1)]
                        // sooo,,, do (Cnma*lk0mlk1).real - (Cnmb*lk0mlk1).imag
                        
                        let A:Complex = Cnma*lk0mlk1
                        let B:Complex = Cnmb*lk0mlk1
                        
                        chi = (A.a - B.b) * powf((k[0]*k[0]*self.lambda*self.lambda + k[1]*k[1]*self.lambda*self.lambda), ((n - m + Float(1.0)) / Float(2.0))) / (n + Float(1.0)) + chi
                    }
                    
                    // why is this here?
                    if k[0] == 0 && k[1] == 0 {
                        chi = 0
                    }
                    
                    //calculates complex chi that is used to show probe
                    input = ((Float((2 * Double.pi)) / self.lambda) * chi)
                    chiExp = Complex(cos(input), -sin(input))
                    
                    // sets calculated values for self.waveFunction
                    self.waveFunction.real[self.waveSize*(i) + (j-1)] = chiExp.a
                    self.waveFunction.imag?[self.waveSize*(i) + (j-1)] = chiExp.b
                    
                }
            }
        }
        
        /*
         if fastCalc == true {
         // stuff if fastCalc == true
         // probably what averages rows above/below and assigns to row
         }
         */
        
    }
    
    
    //    var waveFunction;
    
    /*
     override init() {
     super.init()
     
     
     }
     */
    
    
}
