import Tagged

public enum Parameters {
    public enum Key {}
    public enum ETH {}
}

public typealias APIKey = Tagged<Parameters.Key, String>

public typealias ETHAddress = Tagged<Parameters.ETH, String>
