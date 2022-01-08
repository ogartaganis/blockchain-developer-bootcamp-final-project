## Design pattern decisions
So in terms of design patterns, keeping it simple.

1. A contract `Ownable` was included in the project, implementing the simple rules of the owner, providing a modifier.
2. We're inheriting said contract's functionality and also using the modifier `onlyOwner` for a core part of the functionality that should be taken care of by only the owner.