//
//  placeholder.swift
//  MathFramework
//
//  Created by LeBeau Group iMac on 10/3/17.
//  Copyright © 2017 The Handsome Microscopist. All rights reserved.
//

import Foundation

//in playground:

/*
 let abb = Aberratio(2, 3, 0, 10)
 
 let probe1 = Probe(512)
 probe1.apertureSize = 10
 
 let probe2 = probe1.probeWithAberration([abb], probe1.realSize, probe1.apertureSize, probe1.lambda, NSSize(width: probe1.waveSize, height: probe1.waveSize))
 
 probe2.calculateProbe()
 
 //let n = probe2.waveFunction
 
 
 //let shift = probe2.waveFunction
 
 
 
 
 public func fftShift (_ shift:Probe) -> (Matrix) {
 
 let rows = shift.waveFunction.rows
 let columns = shift.waveFunction.columns
 //let rad = shift.apertureSize
 let count = shift.waveFunction.real.count
 
 let iMid:Int = rows/2
 let jMid:Int = columns/2
 
 let radius = Float(iMid/4)
 
 var temp1:Float
 var temp2:Float
 
 var output = Matrix(rows, columns, "real")
 
 for i in 1...rows {
 for j in 1...columns {
 
 var x0 = Float(i) - radius
 var y0 = Float(j) - radius
 var n = x0*x0 + y0*y0
 
 //let ap = (shift.apertureSize*1E-3)/shift.lambda
 let r = radius*radius
 
 if n <= r {
 // center circle
 temp1 = shift.waveFunction.real[count*(i - 1) + (j - 1)]
 
 if Float(i*i + j*j) <= r {
 // top left corner
 temp2 = shift.waveFunction.real[count*(iMid - i - 1) + (jMid - j - 1)]
 output.real[count*(iMid - i - 1) + (jMid - j - 1)] = temp1
 
 } else if Float((columns - i)*(columns - i) + j*j) <= r {
 // top right corner
 temp2 = shift.waveFunction.real[count*(iMid + i - 1) + (jMid - j - 1)]
 output.real[count*(iMid + i - 1) + (jMid - j - 1)] = temp1
 
 } else if Float((columns - i)*(columns - i) + (rows - j)*(rows - j)) <= r {
 // bottom right corner
 temp2 = shift.waveFunction.real[count*(iMid + i - 1) + (jMid + j - 1)]
 output.real[count*(iMid + i - 1) + (jMid + j - 1)] = temp1
 
 } else if Float(i*i + (rows - j)*(rows - j)) <= r {
 // bottom left corner
 temp2 = shift.waveFunction.real[count*(iMid - i - 1) + (jMid + j - 1)]
 output.real[count*(iMid - i - 1) + (jMid + j - 1)] = temp1
 } else {
 temp2 = Float(0)
 }
 
 output.real[count*(i - 1) + (j - 1)] = temp2
 }
 }
 }
 return output
 }
 
 
 
 //let shift = fftShift(probe2)
 
 
 
 
 
 
 
 
 var copy = Matrix(512, 512, "complex")
 //print (probe2.waveFunction.real)
 //copy = probe2.waveFunction
 //fftShift(copy)
 //copy.real = probe2.waveFunction.real
 //copy.imag = probe2.waveFunction.imag
 //fftShift(probe2.waveFunction)
 
 // stopping point:
 //  keep getting "index out of range" error messages
 //  need to just work through code by hand w/ smaller matrix or something
 
 
*/
















