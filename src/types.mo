import StableBuffer "mo:stable-buffer";

module {

  /// Red-black tree of key `Nat`.
  public type Tree = ?({ #R; #B }, Tree, Nat, Tree);

  public type Return<T> = StableBuffer.Return<T>;

  public type State = {
    buffer_state : StableBuffer.State;
    var tree : Tree;
  };

};