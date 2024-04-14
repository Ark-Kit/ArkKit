protocol Rule<Trigger> {
    associatedtype Trigger: Equatable
    associatedtype Data
    associatedtype ExternalResources: ArkExternalResources

    var trigger: Trigger { get }
    var action: any Action<Data, ExternalResources> { get }
    var conditions: [RuleCondition] { get }
}

struct ArkRule<Trigger, Data, ExternalResources>: Rule
where Trigger: Equatable, ExternalResources: ArkExternalResources {
    let trigger: Trigger

    let action: any Action<Data, ExternalResources>
    var conditions: [RuleCondition] = []
}

typealias RuleCondition = (ArkECSContext) -> Bool
