/// `Enumeration<K>` is a "set enumeration" of elements of type `K` called "keys".
///
/// A typical application is to assign permanent user numbers to princpals.
///
/// The data structure is a map `Nat -> K` with the following properties:
/// * keys are not repeated, i.e. the map is injective
/// * keys are consecutively numbered (no gaps), i.e. if n keys are stored
///   then `[0,n) -> K` is bijective
/// * keys are numbered in the order they are added to the data structure
/// * keys cannot be deleted
/// * efficient inverse lookup `K -> Nat`
/// * doubles as a set implementation (without deletion)
///
/// The data structure is optimized primarily for memory efficiency
/// and secondarily for instruction efficiency.
///
/// Copyright: 2023 MR Research AG
/// Main author: Andrii Stepanov (AStepanov25)
/// Contributors: Timo Hanke (timohanke), Yurii Pytomets (Pitometsu)

import { blobCompare } "mo:⛔";
import SB "mo:stable-buffer";
import T "../types";

module {


  /// Common functions between both classes
  func lbalance(left : T.Tree, y : Nat, right : T.Tree) : T.Tree {
    switch (left, right) {
      case (?(#R, ?(#R, l1, y1, r1), y2, r2), r) ?(#R, ?(#B, l1, y1, r1), y2, ?(#B, r2, y, r));
      case (?(#R, l1, y1, ?(#R, l2, y2, r2)), r) ?(#R, ?(#B, l1, y1, l2), y2, ?(#B, r2, y, r));
      case _ ?(#B, left, y, right);
    };
  };

  func rbalance(left : T.Tree, y : Nat, right : T.Tree) : T.Tree {
    switch (left, right) {
      case (l, ?(#R, l1, y1, ?(#R, l2, y2, r2))) ?(#R, ?(#B, l, y, l1), y1, ?(#B, l2, y2, r2));
      case (l, ?(#R, ?(#R, l1, y1, r1), y2, r2)) ?(#R, ?(#B, l, y, l1), y1, ?(#B, r1, y2, r2));
      case _ ?(#B, left, y, right);
    };
  };

  public class Enumeration(state: T.State) {

    let buffer = SB.StableBuffer( state.buffer_state );
    
    public let vals = buffer.vals;

    /// Add `key` to enumeration. Returns `size` if the key in new to the enumeration and index of key in enumeration otherwise.
    ///
    /// Example:
    /// ```motoko
    /// let e = Enumeration.EnumerationBlob();
    /// assert(e.add("abc") == 0);
    /// assert(e.add("aaa") == 1);
    /// assert(e.add("abc") == 0);
    /// ```
    /// Runtime: O(log(n))
    public func add(key : Blob) : T.Return<Nat> {
      var index = buffer.size();

      func insert(tree : T.Tree) : T.Tree {
        switch tree {
          case (?(#B, left, y, right)) {
            let res = blobCompare(key, buffer.get(y));
            if (res < 0) {
              lbalance(insert(left), y, right);
            } else if (res > 0) {
              rbalance(left, y, insert(right));
            } else {
              index := y;
              tree;
            };
          };
          case (?(#R, left, y, right)) {
            let res = blobCompare(key, buffer.get(y));
            if (res < 0) {
              ?(#R, insert(left), y, right);
            } else if (res > 0) {
              ?(#R, left, y, insert(right));
            } else {
              index := y;
              tree;
            };
          };
          case (null) {
            index := buffer.size();
            ?(#R, null, buffer.size(), null);
          };
        };
      };

      state.tree := switch (insert( state.tree )) {
        case (?(#R, left, y, right)) ?(#B, left, y, right);
        case other other;
      };

      buffer.add( key )

    };

    /// Returns `?index` where `index` is the index of `key` in order it was added to enumeration, or `null` it `key` wasn't added.
    ///
    /// Example:
    /// ```motoko
    /// let e = Enumeration.EnumerationBlob();
    /// assert(e.add("abc") == 0);
    /// assert(e.add("aaa") == 1);
    /// assert(e.lookup("abc") == ?0);
    /// assert(e.lookup("aaa") == ?1);
    /// assert(e.lookup("bbb") == null);
    /// ```
    /// Runtime: O(log(n))
    public func lookup(key : Blob) : ?Nat {
      func get_in_tree(x : Blob, t : T.Tree) : ?Nat {
        switch t {
          case (?(_, l, y, r)) {

            let res = blobCompare(key, buffer.get(y));
            if (res < 0) {
              get_in_tree(x, l);
            } else if (res > 0) {
              get_in_tree(x, r);
            } else {
              ?y;
            };
          };
          case (null) null;
        };
      };

      get_in_tree(key, state.tree);
    };

    /// Returns `K` with index `index`. Traps it index is out of bounds.
    ///
    /// Example:
    /// ```motoko
    /// let e = Enumeration.EnumerationBlob();
    /// assert(e.add("abc") == 0);
    /// assert(e.add("aaa") == 1);
    /// assert(e.get(0) == "abc");
    /// assert(e.get(1) == "aaa");
    /// ```
    /// Runtime: O(1)
    public let get = buffer.get;

    /// Returns number of unique keys added to enumeration.
    ///
    /// Example:
    /// ```motoko
    /// let e = Enumeration.EnumerationBlob();
    /// assert(e.add("abc") == 0);
    /// assert(e.add("aaa") == 1);
    /// assert(e.size() == 2);
    /// ```
    /// Runtime: O(1)
    public let size = buffer.size;
  
  }

};
