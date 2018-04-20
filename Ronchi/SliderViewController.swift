//
//  C01.swift
//  Ronchi
//
//  Created by LeBeau Group iMac on 10/31/17.
//  Copyright © 2017 The Handsome Microscopist. All rights reserved.
//

import Cocoa
import Accelerate
import MathFramework

class SliderViewController:NSViewController {
    
    @IBOutlet weak var aberrationTitle: NSTextField!
    @IBOutlet weak var cnma: NSSlider!
    @IBOutlet weak var cnmaText: NSTextField!
    @IBOutlet weak var cnmb: NSSlider!
    @IBOutlet weak var cnmbText: NSTextField!
    
    
    @IBAction func cnma(_ sender: Any) {
        
        // 1. which aberration triggered the segue?
        // 2. what is current value of Cnma?
        // 3. scale slider to Cnma max/min
        // 4. send new Cnma to main view controller
        //      have that^ trigger update of theImage and aberrationTable
        
        // need to figure out how to easily retrieve and update NSTableView values
        // also how to send data between two view controllers
        
        //let cnma = sender.floatValue
            // apparently there is no member floatValue, yay
            // i was going to have to re-scale this thing anyways, depending on aberration
        
        // if statements depending on state of modeButtons
        // need a dictionary for [ca, cb]:probe.setAberrations[i]
        // use ^ to set probe.setAberrations[i] = [ca, cb, cnma, cnmb]
        // step one: figure out how to get which disclosure button made the view show up, the state of modeButtons,
            // and the variable probe, out of ViewController and into SliderViewController (and back again)
        // cause this file is where everything is going to happen
        
    }
    
    @IBAction func cnmb(_ sender: Any) {
        
        // same 1. - 4. as cnma slider, but for cnmb
        
    }
    
    
}




