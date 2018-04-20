//
//  Fourier Transform in Swift
//  Ronchigram
//
//  Created by James LeBeau on 5/24/17.
//  Copyright © 2017 The Handsome Microscopist. All rights reserved.
//

import Foundation
import Accelerate
//import MathFramework


public class FFTController: NSObject {
    
    // Initialization of class
    
    public var fftSetup:vDSP_DFT_Setup
    
    public var inputMatrix:Matrix
    public var outputMatrix:Matrix
    
    public init(_ input:Matrix) {
        
        let n = UInt(log2(Double(input.count)))
        
        self.inputMatrix = input
        
        self.outputMatrix = Matrix(input.rows, input.columns, input.type)
        
        self.fftSetup =  vDSP_create_fftsetup(n, FFTRadix(kFFTRadix2))!
        
        super.init()
    }
    
    
    // In-place Fourier transform of an input matrix
    
    public func fftInPlace(_ transform:Matrix) {
        
        var testDSP =  DSPSplitComplex.init(realp: &transform.real, imagp: &transform.imag!)
        
        let n = UInt((log2(Double(transform.rows))/2))
        
        vDSP_fft2d_zip(fftSetup, &testDSP, 1, 0, n, n, FFTDirection(kFFTDirection_Forward))
    }
    
    
    
    // In-place inverse Fourier transform of an imput matrix
    
    public func fftInPlaceInv(_ transform: Matrix) {
        
        var testDSP = DSPSplitComplex.init(realp: &transform.real, imagp: &transform.imag!)
        
        let n = UInt((log2(Double(transform.count))/2))
        
        vDSP_fft2d_zip(fftSetup, &testDSP, 1, 0, n, n, FFTDirection(kFFTDirection_Inverse))
    }
    
    // Shift-in-place function for use before performing an inverse Fourier transform
    // In shift.real, swaps quadrants 1 and 3, and 2 and 4
    // Intended result: the phase plate circle is cut into quadrants and shifted to the corners
    // Use with aProbe.waveFunction as shift:Matrix to do ^
    
    public func fftShift (_ shift:Matrix) {
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
    
    
    // returns probe matrix when given a phase plate matrix
    // performs fftShift, inverse Fourier transform, fftShift back, and multiplies by complex conjugate to give intensity
    
    public func plateToProbe(_ name:Matrix) -> Matrix {
        
        let con = FFTController.init(name)
        
        con.fftInPlaceInv(con.inputMatrix)
        
        con.fftShift(con.inputMatrix)
        
        let ccCon = complexConj(con.inputMatrix)
        
        let output = ccCon.*con.inputMatrix
        
        return output!
        
    }
    
}








