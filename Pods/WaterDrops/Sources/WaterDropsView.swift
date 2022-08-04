//
//  WaterDropsView.swift
//  WaterDrops
//
//  Created by LeFal on 2017. 8. 17..
//  Copyright © 2017 LeFal. All rights reserved.
//

import UIKit


open class WaterDropsView: UIView {
  
  ///Waterdrop's direction
  open var direction : DropDirection = .up
  
  ///Number of drops
  open var dropNum: Int = 10
  
  
  public enum DropDirection {
    case up
    case down
  }
  
  var isAnimated: Bool = false
  
  ///Waterdrop's color
  open var color: UIColor = UIColor.blue.withAlphaComponent(0.7)
  ///The minimum size of a waterdrop
  open var minDropSize: CGFloat = 4
  ///The maximum size of a waterdrop
  open var maxDropSize: CGFloat = 10
  ///The minimum moving length of a waterdrop
  open var minLength: CGFloat = 0
  ///The maximum moving length of a waterdrop
  open var maxLength: CGFloat = 100
  ///The minimum duration of animation
  open var minDuration: TimeInterval = 4
  ///The maximum duration of animation
  open var maxDuration: TimeInterval = 12
  
  public override init(frame: CGRect) {
    self.dropNum = 10
    self.color = UIColor.blue.withAlphaComponent(0.7)
    self.minDropSize = 4
    self.maxDropSize = 10
    self.minLength = 0
    self.maxLength = 100
    self.minDuration = 4
    self.maxDuration = 12
    super.init(frame: frame)
  }
  
  public init(frame: CGRect, direction: DropDirection = .up, dropNum: Int = 10, color: UIColor = UIColor.blue.withAlphaComponent(0.7), minDropSize: CGFloat = 4, maxDropSize: CGFloat = 10, minLength: CGFloat = 0, maxLength: CGFloat = 100, minDuration: TimeInterval = 4, maxDuration: TimeInterval = 12)  {
    self.direction = direction
    self.dropNum = dropNum
    self.color = color
    self.minDropSize = minDropSize
    self.maxDropSize = maxDropSize
    self.minLength = minLength
    self.maxLength = maxLength
    self.minDuration = minDuration
    self.maxDuration = maxDuration
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  open override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  /// Required : Add water drops animation in view
  public func addAnimation() {
    isAnimated = true
    let viewConfiguration = ViewConfig(color: self.color,
                                       minDropSize: self.minDropSize,
                                       maxDropSize: self.maxDropSize,
                                       minLength: self.minLength,
                                       maxLength: self.maxLength,
                                       minDuration: self.minDuration,
                                       maxDuration: self.maxDuration)
    makeRandomWaterDrops(num: dropNum, config: viewConfiguration, direction: direction)
  }
  
  public func updateAnimation() {
    isAnimated = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      self.isAnimated = true
      self.addAnimation()
    }
  }
  
  func makeRandomWaterDrops(num: Int, config: ViewConfig, direction: DropDirection = .up) {
    for _ in 1...num {
      randomWaterdrop(config: config, direction: direction)
    }
  }
  
  func randomWaterdrop(config: ViewConfig, direction: DropDirection = .up) {
    
    // make random number
    let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
    let randomSize: CGFloat = CGFloat(arc4random_uniform(UInt32(config.maxDropSize - config.minDropSize))) + config.minDropSize
    let randomDuration: TimeInterval = TimeInterval(arc4random_uniform(UInt32(config.maxDuration - config.minDuration))) + config.minDuration
    let randomLength: CGFloat =  CGFloat(arc4random_uniform(UInt32(config.maxLength - config.minLength))) + config.minLength
    let length = direction == .up ? -randomLength : randomLength
    
    // make waterdrop
    let positionY = direction == .up ? self.frame.height : -randomSize
    var waterdrop : UIView? = UIView()
    waterdrop?.frame = CGRect(x: randomX, y: positionY, width: randomSize, height: randomSize)
    waterdrop?.backgroundColor = config.color
    waterdrop?.layer.cornerRadius = randomSize/2
    self.addSubview(waterdrop!)
    
    // animation
    UIView.animate(withDuration: randomDuration, animations: {
      if self.isAnimated {
        waterdrop?.frame.origin.y += length
        waterdrop?.alpha = 0.0
      } else {
        return
      }
    }, completion: { isCompleted in
      if isCompleted {
        if self.isAnimated {
          waterdrop = nil
          self.randomWaterdrop(config: config, direction: direction)
        } else {
          return
        }
      }
    })
  }
   
  
  struct ViewConfig {
    let color : UIColor
    let minDropSize : CGFloat
    let maxDropSize: CGFloat
    let minLength : CGFloat
    let maxLength : CGFloat
    let minDuration : TimeInterval
    let maxDuration : TimeInterval
  }
}
