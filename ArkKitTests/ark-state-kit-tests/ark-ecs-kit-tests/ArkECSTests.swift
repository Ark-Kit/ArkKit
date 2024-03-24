import XCTest
@testable import ArkKit

final class ArkECSTests: XCTestCase {

    class MockComponent: Component {
        var name: String

        init(name: String = "MockComponent") {
            self.name = name
        }
    }
    class MockComponent1: Component {}
    class MockComponent2: Component {}

    func testCreateEntity() {
        let arkECS = ArkECS()
        let initialEntityCount = arkECS.getEntities(with: []).count

        let newEntity = arkECS.createEntity()
        XCTAssertNotNil(newEntity, "createEntity should return a new entity.")

        let newEntityCount = arkECS.getEntities(with: []).count
        XCTAssertEqual(newEntityCount, initialEntityCount + 1, "A new entity should be added to the ECS.")
    }

    func testRemoveEntity() {
        let arkECS = ArkECS()
        let entity = arkECS.createEntity()
        let existsBeforeRemoval = arkECS.getEntity(id: entity.id) != nil
        XCTAssertTrue(existsBeforeRemoval, "Entity should exist before removal.")

        arkECS.removeEntity(entity)
        let existsAfterRemoval = arkECS.getEntity(id: entity.id) != nil
        XCTAssertFalse(existsAfterRemoval, "Entity should not exist after removal.")
    }

    func testCreateEntityWithComponents() {
        let arkECS = ArkECS()
        let component1 = MockComponent1()
        let component2 = MockComponent2()

        let entity = arkECS.createEntity(with: [component1, component2])
        XCTAssertNotNil(entity, "Entity should be created with specified components.")

        let retrievedComponent1: MockComponent1? = arkECS.getComponent(ofType: MockComponent1.self, for: entity)
        let retrievedComponent2: MockComponent2? = arkECS.getComponent(ofType: MockComponent2.self, for: entity)
        XCTAssertNotNil(retrievedComponent1, "Entity should have Component1.")
        XCTAssertNotNil(retrievedComponent2, "Entity should have Component2.")
    }

    func testGetEntity() {
        let arkECS = ArkECS()
        let newEntity = arkECS.createEntity()
        let retrievedEntity = arkECS.getEntity(id: newEntity.id)

        XCTAssertNotNil(retrievedEntity, "Should retrieve the entity with the given ID.")
        XCTAssertEqual(retrievedEntity?.id, newEntity.id, "Retrieved entity should have the same ID as the new entity.")

        let nonExistentEntity = arkECS.getEntity(id: UUID())
        XCTAssertNil(nonExistentEntity, "Should return nil for a non-existent entity ID.")
    }

    func testGetEntitiesWithComponentTypes() {
        let arkECS = ArkECS()
        let componentType = MockComponent.self
        let entityWithComponent = arkECS.createEntity()

        arkECS.upsertComponent(MockComponent(), to: entityWithComponent)

        let entityWithoutComponent = arkECS.createEntity()

        let entitiesWithComponent = arkECS.getEntities(with: [componentType])
        XCTAssertTrue(entitiesWithComponent.contains(entityWithComponent),
                      "Should include entities with the specified component type.")
        XCTAssertFalse(entitiesWithComponent.contains(entityWithoutComponent),
                       "Should not include entities without the specified component type.")
    }

    func testUpsertComponent() {
        let arkECS = ArkECS()
        let entity = arkECS.createEntity()
        let component = MockComponent(name: "Component 1")

        arkECS.upsertComponent(component, to: entity)

        let retrievedComponent: MockComponent? = arkECS.getComponent(ofType: MockComponent.self, for: entity)
        XCTAssertNotNil(retrievedComponent, "Component should be added to the entity.")

        let updatedComponent = MockComponent(name: "Component 2")
        arkECS.upsertComponent(updatedComponent, to: entity)

        let retrievedUpdatedComponent: MockComponent? = arkECS.getComponent(ofType: MockComponent.self, for: entity)
        XCTAssertEqual(retrievedUpdatedComponent?.name, updatedComponent.name,
                       "Component should be updated for the entity.")
    }

    func testRemoveComponent() {
        let arkECS = ArkECS()
        let entity = arkECS.createEntity()
        let component = MockComponent()
        arkECS.upsertComponent(component, to: entity)

        // Remove component
        arkECS.removeComponent(MockComponent.self, from: entity)

        let retrievedComponent: MockComponent? = arkECS.getComponent(ofType: MockComponent.self, for: entity)
        XCTAssertNil(retrievedComponent, "Component should be removed from the entity.")
    }

    func testGetComponent() {
        let arkECS = ArkECS()
        let entity = arkECS.createEntity()
        let component = MockComponent()
        arkECS.upsertComponent(component, to: entity)

        let retrievedComponent: MockComponent? = arkECS.getComponent(ofType: MockComponent.self, for: entity)
        XCTAssertNotNil(retrievedComponent, "Should retrieve the added component for the entity.")

        let nonExistentComponent: MockComponent1? = arkECS.getComponent(ofType: MockComponent1.self, for: entity)
        XCTAssertNil(nonExistentComponent, "Should return nil for a non-existent component type.")
    }

    func testGetComponents() {
        let arkECS = ArkECS()
        let entity = arkECS.createEntity()
        let component1 = MockComponent1()
        let component2 = MockComponent2()
        arkECS.upsertComponent(component1, to: entity)
        arkECS.upsertComponent(component2, to: entity)

        // Retrieve all components from the entity
        let components = arkECS.getComponents(from: entity)
        XCTAssertTrue(components.contains(where: { $0 is MockComponent1 }), "Entity should contain MockComponent1.")
        XCTAssertTrue(components.contains(where: { $0 is MockComponent2 }), "Entity should contain MockComponent2.")
    }

}
