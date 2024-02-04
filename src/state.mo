import StableBuffer "mo:stable-buffer";
import T "types";

module {

  public type InitParams = { size : Nat64 };

  public func init(params: InitParams): T.State = {
    buffer_state = StableBuffer.State.init({size = params.size; capacity=1});
    var tree = null;
  };

};