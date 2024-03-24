import XCTest
@testable import ArkKit

struct TestComponent: Component {}

struct AnotherTestComponent: Component {}

class EntityManagerTests: XCTestCase {
    var entityManager: EntityManager!

    override func setUp() {
        super.setUp()
        entityManager = EntityManager()
    }

    func testCreateAndRemoveEntity() {
        let entity = entityManager.createEntity()
        XCTAssertTrue(entityManager.getEntities(with: []).contains(entity),
                      "Entity should be tracked by EntityManager.")

        entityManager.removeEntity(entity)
        XCTAssertFalse(entityManager.getEntities(with: []).contains(entity),
                       "Entity should be removed from EntityManager.")
    }

    func testCreateAndRemoveEntityWithComponent() {
        let entity = entityManager.createEntity(with: [TestComponent()])

        entityManager.removeEntity(entity)
        XCTAssertTrue(entityManager.getEntities(with: [TestComponent.self]).isEmpty,
                      "Entity should be removed from EntityManager.")
    }

    func testCreateEntityWithComponents() {
        let entity = entityManager.createEntity(with: [TestComponent()])

        let retrievedComponent: TestComponent? = entityManager.getComponent(ofType: TestComponent.self, for: entity)
        XCTAssertNotNil(retrievedComponent, "Entity should be created with TestComponent.")
    }

    func testComponentAdditionAndRetrieval() {
        let entity = entityManager.createEntity()
        let testComponent = TestComponent() // Assuming TestComponent conforms to Component

        entityManager.upsertComponent(testComponent, to: entity)
        let retrievedComponent: TestComponent? = entityManager.getComponent(ofType: TestComponent.self, for: entity)

        XCTAssertNotNil(retrievedComponent, "Should retrieve the added component.")
    }

    func testComponentRemoval() {
        let entity = entityManager.createEntity()
        let testComponent = TestComponent()

        entityManager.upsertComponent(testComponent, to: entity)
        entityManager.removeComponent(ofType: TestComponent.self, from: entity)

        let retrievedComponent: TestComponent? = entityManager.getComponent(ofType: TestComponent.self, for: entity)
        XCTAssertNil(retrievedComponent, "Component should be removed from the entity.")
    }

    func testRetrievingEntitiesByComponentType() {
        let entity1 = entityManager.createEntity()
        let entity2 = entityManager.createEntity()
        let testComponent1 = TestComponent()
        let testComponent2 = AnotherTestComponent()

        entityManager.upsertComponent(testComponent1, to: entity1)
        entityManager.upsertComponent(testComponent2, to: entity2)

        let entitiesWithTestComponent = entityManager.getEntities(with: [TestComponent.self])
        let entitiesWithBothComponents = entityManager.getEntities(with: [TestComponent.self,
                                                                          AnotherTestComponent.self])

        XCTAssertEqual(entitiesWithTestComponent.count, 1, "Should find 1 entity with TestComponent.")
        XCTAssertEqual(entitiesWithBothComponents.count, 0,
                       "Should find no entities with both TestComponent and AnotherTestComponent.")
    }

    func testRetrievingEntitiesWithMultipleComponentType() {
        let entity1 = entityManager.createEntity()
        let entity2 = entityManager.createEntity()
        let testComponent1 = TestComponent()
        let testComponent2 = AnotherTestComponent()

        entityManager.upsertComponent(testComponent1, to: entity1)
        entityManager.upsertComponent(testComponent2, to: entity1)
        entityManager.upsertComponent(testComponent2, to: entity2)

        let entitiesWithTestComponent = entityManager.getEntities(with: [TestComponent.self])
        let entitiesWithAnotherTestComponent = entityManager.getEntities(with: [AnotherTestComponent.self])
        let entitiesWithBothComponents = entityManager.getEntities(with: [TestComponent.self,
                                                                          AnotherTestComponent.self])

        XCTAssertEqual(entitiesWithTestComponent.count, 1, "Should find 1 entity with TestComponent.")
        XCTAssertEqual(entitiesWithAnotherTestComponent.count, 2, "Should find 2 entitie with AnotherTestComponent.")
        XCTAssertEqual(entitiesWithBothComponents.count, 1,
                       "Should find 1 entity with TestComponent and AnotherTestComponent.")
    }
}
