## Avoiding common attacks
For sure there could be a better job here but here's what's done:
1. We used a specific pragma version. No longer unwanted behaviour, since we're in control!
2. We used a modifier to validate that only our owner is allowed to perform an action. Any other modifiers are omitted and included as conditions inside our functions.