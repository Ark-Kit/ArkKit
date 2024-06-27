/// A facade which encapsulates all the sub-contexts used in the `ArkBlueprint` state setup function.
public struct ArkSetupContext {
    public let ecs: ArkECSContext
    public let events: ArkEventContext
    public let display: DisplayContext
}
