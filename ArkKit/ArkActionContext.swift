/**
 * A facade which encapsulates all the sub-contexts used in the execution of an action in `ArkBlueprint`.
 */
struct ArkActionContext {
    let ecs: ArkECS
    let events: ArkEventManager
    let display: ArkDisplayContext
}
