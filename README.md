# stable-enum

## Disclaimer
The vast majority of code included in this repo was originally created by MR Research AG

The unmodified source code can be found here: https://github.com/research-ag/enumeration

The original license and copyright notices are include in the ./src/class directory.

The general purpose Enumeration<K> class has been removed entirely.

The EnumerationBlob class been renamed Enumeration and modified so that its state
data is initialized outside of the class object. Additionally, EnumerationBlob's
array has been replaced by a StableBuffer that allows fixed-size data entries to be written
directly to and retrieved from a stable memory region.

The modifications outlined above have not been benchmarked; therefore, performance claims
included in the original README have been removed.

## Overview

`Enumeration` implements an add-only set of elements of type Blob where the
elements are numbered in the order in which they are added to the set.
The elements are called *keys* and a key's number in the order is called *index*.
Lookups are possible in both ways, from key to index and from index to key.

## Usage

### Install with mops

You need `mops` installed. In your project directory run:
```
mops add stable-enum
```

In the Motoko source file import the package as:
```
import Enum "mo:stable-enum";
```

### Example

State data is initialized outside of the class using an init function.

Enum entries must be a fixed size. The size is configured during state initialization.

```
stable let state = Enum.State.init({ size = 122 });
let e = Enum.Enumeration( state );
e.add("\00\01\02"); // -> #ok(0)
e.add("\00\00\00"); // -> #ok(1)
e.add("\00\01\02"); // -> #ok(0)
e.lookup("\00\00\00"); // -> ?1
e.get(0); // -> "\00\01\02"
e.get(1); // -> "\00\00\00"
```