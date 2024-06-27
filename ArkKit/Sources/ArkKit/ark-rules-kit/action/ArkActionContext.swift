/**
 * A facade which encapsulates all the sub-contexts used in the execution of an action in `ArkBlueprint`.
 */
public struct ArkActionContext<ExternalResources: ArkExternalResources>: ArkActionContextProtocol {
    public let ecs: ArkECSContext
    public let events: ArkEventContext
    public let display: DisplayContext
    public let audio: any AudioContext<ExternalResources.AudioEnum>
}

public protocol ArkActionContextProtocol {
    associatedtype ExternalResources: ArkExternalResources

    var ecs: ArkECSContext { get }
    var events: ArkEventContext { get }
    var display: DisplayContext { get }
    var audio: any AudioContext<ExternalResources.AudioEnum> { get }
}
