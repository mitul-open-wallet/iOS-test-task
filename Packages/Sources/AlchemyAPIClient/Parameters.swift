import Tagged

public enum Key {}
public typealias APIKey = Tagged<Key, String>

public enum ETH {}
public typealias ETHAddress = Tagged<ETH, String>
