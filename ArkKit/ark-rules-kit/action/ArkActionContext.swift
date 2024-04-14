/**
 * A facade which encapsulates all the sub-contexts used in the execution of an action in `ArkBlueprint`.
 */
struct ArkActionContext<ExternalResources: ArkExternalResources>: ArkActionContextProtocol {
    let ecs: ArkECSContext
    let events: ArkEventContext
    let display: DisplayContext
    let audio: any AudioContext<ExternalResources.AudioEnum>
}

protocol ArkActionContextProtocol {
    associatedtype ExternalResources: ArkExternalResources

    var ecs: ArkECSContext { get }
    var events: ArkEventContext { get }
    var display: DisplayContext { get }
    var audio: any AudioContext<ExternalResources.AudioEnum> { get }
}
