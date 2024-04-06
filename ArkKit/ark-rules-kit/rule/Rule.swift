protocol Rule<Trigger> {
    associatedtype Trigger: Equatable
    associatedtype Data
    associatedtype AudioEnum: ArkAudioEnum

    var trigger: Trigger { get }
    var action: any Action<Data, AudioEnum> { get }
    var conditions: [RuleCondition] { get }
}

struct ArkRule<Trigger, Data, AudioEnum>: Rule where Trigger: Equatable, AudioEnum: ArkAudioEnum {
    let trigger: Trigger

    let action: any Action<Data, AudioEnum>
    var conditions: [RuleCondition] = []
}

typealias RuleCondition = (ArkECSContext) -> Bool
