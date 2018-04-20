//: Playground - noun: a place where people can play

import Cocoa
import MathFramework
import Accelerate



var circle = Matrix(64, 64, "complex")

func drawCircle(_ innRad: Int, _ outRad: Int) -> Matrix {
    
    let xo = Int(circle.rows/2)
    let yo = Int(circle.columns/2)
    let r = outRad
    let r2 = innRad
    let rows = circle.rows-1
    let columns = circle.columns-1
    let valid:Bool
    let img:CGImage?
    
    valid = checkRadius(innRad, outRad)
    
    if valid == true {
        for i in 0...rows {
            for j in 0...columns {
                if (i-xo)*(i-xo) + (j-yo)*(j-yo) <= r*r && (i-xo)*(i-xo) + (j-yo)*(j-yo) >= r2*r2 {
                    circle.real[i*circle.columns + j] = Float(1)
                } else {
                    circle.real[i*circle.columns + j] = 0.0
                }
            }
        }
    }
    return circle
}

func checkRadius(_ inner: Int, _ outer: Int) -> Bool {
    if inner <= outer {
        return true
    } else {
        return false
    }
}


var mat = drawCircle(0, 20)
mat.imag = mat.real

public func fftShift (_ shift:Matrix) -> () {
    let rows = shift.rows
    let cols = shift.columns
    let iMid:Int = rows/2
    let jMid:Int = cols/2
    var swapI:Int
    var swapJ:Int
    var temp1:Float
    var temp2:Float
    
    for i in 0..<rows {
        for j in 0..<jMid {
            if i < iMid {
                swapI = iMid + i
                swapJ = jMid + j
            } else {
                swapI = i - iMid
                swapJ = j + jMid
            }
            temp1 = shift.real[cols*i + j]
            temp2 = shift.real[cols*swapI + swapJ]
            
            shift.real[cols*swapI + swapJ] = temp1
            shift.real[cols*i + j] = temp2
        }
    }
}

fftShift(mat)

mat


//var fftSetup:vDSP_DFT_Setup

//fftSetup =  vDSP_create_fftsetup(UInt(log2(Double(mat.count))), FFTRadix(kFFTRadix2))!

/*
var fftSetup = vDSP_create_fftsetup(16, FFTRadix(kFFTRadix2))!

// In-place Fourier transform of an input matrix
    
public func fftInPlace(_ transform:Matrix) {
        
    var testDSP =  DSPSplitComplex.init(realp: &transform.real, imagp: &transform.imag!)
        
    let n = UInt(log2(Double(transform.count)))
        
    vDSP_fft2d_zip(fftSetup, &testDSP, 1, 1, n, n, FFTDirection(kFFTDirection_Forward))
        
}
    
    
    // In-place inverse Fourier transform of an input matrix
    
public func fftInPlaceInv(_ transform: Matrix) {
        
    var testDSP = DSPSplitComplex.init(realp: &transform.real, imagp: &transform.imag!)
        
    let n = UInt(log2(Double(transform.count)))
        
    vDSP_fft2d_zip(fftSetup, &testDSP, 1, 1, n, n, FFTDirection(kFFTDirection_Inverse))
}

//let no = Int(23.4)





//fftInPlace(mat)


mat
*/
 
 
// when uncomment above two lines (ie, try to transform and view mat), get the following error message:

/*
 fatal error: Float value cannot be converted to UInt8 because it is either infinite or NaN
 objc[22652]: autorelease pool page 0x7fa102856000 corrupted
 magic     0xffc00000 0xffc00000 0xffc00000 0xffc00000
 should be 0xa1a1a1a1 0x4f545541 0x454c4552 0x21455341
 pthread   0xffc00000ffc00000
 should be 0x70000083e000
 
*/

// so...another problem with normalizing between 0 and 1 because something in mat got real big or real small
// boy i wish i could remember how i fixed this last time







