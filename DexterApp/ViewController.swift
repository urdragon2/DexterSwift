//
//  ViewController.swift
//  DexterApp
//
//  Created by Dwayne Kurfirst on 7/17/17.
//  Copyright © 2017 kurfirstcorp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgBluetoothStatus: UIImageView!
    
    @IBOutlet weak var positionSlider: UISlider!
    
    @IBOutlet weak var upbutton: UIImageView!

    @IBOutlet weak var rightbutton: UIImageView!
    
    @IBOutlet weak var leftbutton: UIImageView!
    
    @IBOutlet weak var downbutton: UIImageView!
    
    @IBOutlet weak var stopbutton: UIImageView!
    
    @IBOutlet weak var motioncontrol: UIImageView!
    
    var timerTXDelay: Timer?
    var allowTX = true
    var lastPosition: UInt8 = 255
    var MovelastPosition: UInt8 = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGestureRecognizer0 = UITapGestureRecognizer(target: self, action: #selector(stopTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(leftTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(upTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(rightTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(downTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(motionTapped(tapGestureRecognizer:)))
        stopbutton.isUserInteractionEnabled = true
        stopbutton.addGestureRecognizer(tapGestureRecognizer0)
        stopbutton.tag = 0
        
        leftbutton.isUserInteractionEnabled = true
        leftbutton.addGestureRecognizer(tapGestureRecognizer1)
        leftbutton.tag = 1
        
        upbutton.isUserInteractionEnabled = true
        upbutton.addGestureRecognizer(tapGestureRecognizer2)
        upbutton.tag = 2
        
        rightbutton.isUserInteractionEnabled = true
        rightbutton.addGestureRecognizer(tapGestureRecognizer3)
        rightbutton.tag = 3
        
        downbutton.isUserInteractionEnabled = true
        downbutton.addGestureRecognizer(tapGestureRecognizer4)
        downbutton.tag = 4
        
        motioncontrol.isUserInteractionEnabled = true
        motioncontrol.addGestureRecognizer(tapGestureRecognizer5)
        motioncontrol.tag = 5
        
        
        // Rotate slider to vertical position
        let superView = self.positionSlider.superview
        positionSlider.removeFromSuperview()
        positionSlider.removeConstraints(self.view.constraints)
        positionSlider.translatesAutoresizingMaskIntoConstraints = true
        positionSlider.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        positionSlider.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 300.0)
        superView?.addSubview(self.positionSlider)
        positionSlider.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
        positionSlider.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        // Set thumb image on slider
        positionSlider.setThumbImage(UIImage(named: "Bar"), for: UIControlState())
        
        // Watch Bluetooth connection
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.connectionChanged(_:)), name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification), object: nil)
        
        // Start the Bluetooth discovery process
        _ = btDiscoverySharedInstance
    }
    
    func stopTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        upbutton.image = UIImage(named: "uparrow")
        rightbutton.image = UIImage(named: "rightarrow")
        leftbutton.image = UIImage(named: "leftarrow")
        downbutton.image = UIImage(named: "downarrow")
        stopbutton.image = UIImage(named: "center")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(named: "centerpushed")
        self.sendMove(UInt8(4))
    }
    
    func leftTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        upbutton.image = UIImage(named: "uparrow")
        rightbutton.image = UIImage(named: "rightarrow")
        leftbutton.image = UIImage(named: "leftarrow")
        downbutton.image = UIImage(named: "downarrow")
        stopbutton.image = UIImage(named: "center")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(named: "leftarrowpushed")
        self.sendMove(UInt8(0))
    }
    
    func upTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        upbutton.image = UIImage(named: "uparrow")
        rightbutton.image = UIImage(named: "rightarrow")
        leftbutton.image = UIImage(named: "leftarrow")
        downbutton.image = UIImage(named: "downarrow")
        stopbutton.image = UIImage(named: "center")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(named: "uparrowpushed")
        self.sendMove(UInt8(1))
    }
    
    func rightTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        upbutton.image = UIImage(named: "uparrow")
        rightbutton.image = UIImage(named: "rightarrow")
        leftbutton.image = UIImage(named: "leftarrow")
        downbutton.image = UIImage(named: "downarrow")
        stopbutton.image = UIImage(named: "center")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(named: "rightarrowpushed")
        self.sendMove(UInt8(2))
    }
    
    func downTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        upbutton.image = UIImage(named: "uparrow")
        rightbutton.image = UIImage(named: "rightarrow")
        leftbutton.image = UIImage(named: "leftarrow")
        downbutton.image = UIImage(named: "downarrow")
        stopbutton.image = UIImage(named: "center")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.image = UIImage(named: "downarrowpushed")
        self.sendMove(UInt8(3))
    }
    
    func motionTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        upbutton.image = UIImage(named: "uparrow")
        rightbutton.image = UIImage(named: "rightarrow")
        leftbutton.image = UIImage(named: "leftarrow")
        downbutton.image = UIImage(named: "downarrow")
        stopbutton.image = UIImage(named: "center")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage.image == UIImage(named: "autonomous")
        {
            stopbutton.image = UIImage(named: "centerpushed")
            tappedImage.image = UIImage(named: "manual")
        }else{
            tappedImage.image = UIImage(named: "autonomous")
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimerTXDelay()
    }
    
    
    @IBAction func positionSliderChanged(_ sender: UISlider) {
        self.sendPosition(UInt8(sender.value))
    }
    
    
    func connectionChanged(_ notification: Notification) {
        // Connection status changed. Indicate on GUI.
        let userInfo = (notification as NSNotification).userInfo as! [String: Bool]
        
        DispatchQueue.main.async(execute: {
            // Set image based on connection status
            if let isConnected: Bool = userInfo["isConnected"] {
                if isConnected {
                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Connected")
                    
                    // Send current slider position
                    self.sendPosition(UInt8( self.positionSlider.value))
                } else {
                    self.imgBluetoothStatus.image = UIImage(named: "Bluetooth_Disconnected")
                }
            }
        });
    }
    
    func sendPosition(_ position: UInt8) {
        
        // 1
        if !allowTX {
            return
        }
        
        // 2
        // Validate value
        if position == lastPosition {
            return
        }
            // 3
        else if ((position < 0) || (position > 180)) {
            return
        }
        
        // 4
        // Send position to BLE Shield (if service exists and is connected)
        if let bleService = btDiscoverySharedInstance.bleService {
            bleService.writePosition(position)
            lastPosition = position
            
            // 5
            // Start delay timer
            allowTX = false
            if timerTXDelay == nil {
                timerTXDelay = Timer.scheduledTimer(timeInterval: 0.1,
                                                    target: self,
                                                    selector: #selector(ViewController.timerTXDelayElapsed),
                                                    userInfo: nil,
                                                    repeats: false)
            }
        }
        
    }
    
    
    func sendMove(_ position: UInt8) {
        
        // 1
        if !allowTX {
            return
        }
        
        // 2
        // Validate value
        if position == MovelastPosition {
            return
        }
        if let bleService = btDiscoverySharedInstance.bleService {
            bleService.writePosition(position)
            MovelastPosition = position
            
            // 5
            // Start delay timer
            allowTX = false
            if timerTXDelay == nil {
                timerTXDelay = Timer.scheduledTimer(timeInterval: 0.1,
                                                    target: self,
                                                    selector: #selector(ViewController.movetimerTXDelayElapsed),
                                                    userInfo: nil,
                                                    repeats: false)
            }
        }
        
    }
    
    func movetimerTXDelayElapsed() {
        self.allowTX = true
        self.stopTimerTXDelay()
        
        // Send current slider position
        self.sendPosition(UInt8(self.positionSlider.value))
    }
    
    func timerTXDelayElapsed() {
        self.allowTX = true
        self.stopTimerTXDelay()
        
        // Send current slider position
        self.sendPosition(UInt8(self.positionSlider.value))
    }
    
    func stopTimerTXDelay() {
        if self.timerTXDelay == nil {
            return
        }
        
        timerTXDelay?.invalidate()
        self.timerTXDelay = nil
    }


}

