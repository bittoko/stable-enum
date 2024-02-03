import Prim "mo:⛔";

module {

  public type Region = Prim.Types.Region;

  /// Red-black tree of key `Nat`.
  public type Tree = ?({ #R; #B }, Tree, Nat, Tree);

  public type StableArray = {
    var next : Nat;
    var capacity: Nat64;
    element_size : Nat64;
    elements : Region;
  };

  public type State = {
    var block_size : Nat;
    var array : StableArray;
    var tree : Tree;
    var size : Nat;
  };

};