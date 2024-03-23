/// A facade which encapsulates all the sub-contexts used in the `ArkBlueprint` state setup function.
struct ArkSetupContext {
    let ecs: ArkECSContext
    let events: ArkEventContext
    let display: ArkDisplayContext
}
