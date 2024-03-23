/// CategoryBitMask
/// Defines the categories the physics body belongs to. 
/// It's used to identify the body during collision and contact tests.

/// CollisionBitMask
/// Specifies the categories of bodies that this body should collide with. 
/// When two bodies collide, their physical interaction (e.g., bouncing off each other) 
/// is determined by their collisionBitMasks.

/**
 * ContactTestBitMask
 * Determines which collisions will notify the delegate.
 * When two bodies collide, if their category bit masks match the contactTestBitMask of the other body,
 * the didBegin(_:) or didEnd(_:) methods of the SKPhysicsContactDelegate are called,
 * allowing you to respond to the event in code.
 */

// This was generated using GPT to show how to use the bitmasking

import Foundation

// Define the physics categories for different objects in the game
struct DemoPhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0x1 << 0 // Binary 01
    static let enemy: UInt32 = 0x1 << 1  // Binary 10
    static let coin: UInt32 = 0x1 << 2   // Binary 100
}

let demoDummyShape = PhysicsComponent.Shape.circle
let demoDummyRadius = CGFloat(10)

/// If I want to create an enemy that passes through a player and a coin but has a contact emitted with a player
let demoEnemyPhysicsComponent = PhysicsComponent(
    shape: demoDummyShape,
    radius: demoDummyRadius,
    categoryBitMask: DemoPhysicsCategory.enemy,
    collisionBitMask: DemoPhysicsCategory.none, // Passes through everything
    contactTestBitMask: DemoPhysicsCategory.player) // Emits contact with the player

/// If I want to create a player that emits a contact when touches a coin and enemy, but passes through them physically
let demoPlayerPhysicsComponent = PhysicsComponent(
    shape: demoDummyShape,
    radius: demoDummyRadius,
    categoryBitMask: DemoPhysicsCategory.player,
    collisionBitMask: DemoPhysicsCategory.none, // No physical collisions
    contactTestBitMask: DemoPhysicsCategory.enemy | DemoPhysicsCategory.coin) // Emits contact with both

/// If I want to want coins to bounce of one another
let demoCoinPhysicsComponent = PhysicsComponent(
    shape: demoDummyShape,
    radius: demoDummyRadius,
    categoryBitMask: DemoPhysicsCategory.coin,
    collisionBitMask: DemoPhysicsCategory.coin, // Collides with other coins
    contactTestBitMask: DemoPhysicsCategory.none) // No need for contact emission
