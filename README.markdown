# NuGenerator

NuGenerator is a rather ugly proof-of-concept implementation of generators in Nu.  It's more of a hack than anything else, but it works and will hopefully stir up some conversation on the best way to implement generators or otherwise extend the Nu language.

NuGenerator is, at the moment, somewhat of a Frankenstein creation.  My first thought was that there may be some way to implement a generator pattern on top of the C stack.  There are certainly some very clever implementations out there, but they were all hacks that exploited features of the C language or were otherwise rather unstable (requiring certain systems to do certain things).  I'd much rather work on something more stable rather than abuse C or hope that the current stack is obliterated after a `setjmp` call.

After deciding to ditch a strict C-stack implementation, I decided to go at it through the Nu runtime.  This seemed much more logical.  At first, I thought I might be able to simple made a few additions on top of Nu in order to make it happen.  Indeed, the runtime is very flexible in the ability to add new keywords and operators.  Unfortunately, implementing `yield` meant getting a bit more intimate with how Nu worked under the hood.  Fortunately, Objective-C is a dynamic language that let me override Nu's implementation of looping operators easily without the tedium of re-compiling Nu.

In the end, I've added a new operator to Nu (`yield`), created a new exception (`NuYieldException`), and made minor changes to the `for`, `while`, and `until` operators.  I think that I've finally implemented what can conceivably be called "generators" in Nu.  At least, they work well enough that it shouldn't matter from the user standpoint.


## The way NuGenerator works

This is a rather complicated system, but here it goes.

Whenever the `yield` operator is encountered, NuYieldOperator is called.  NYO basically throws an exception (`NuYieldException`) that is then returned by the looping operation.  It's somewhat similar to if the operation had a return statement which returned the exception.  The exception itself is the generator.  At present, it only responds to the `each:` command, but other enumerator methods will be added.

When `each:` is called on NuGenerator, it will first return the initial value but subsequent runs will finish the loop (if possible) and then reiterate until it hits the `yield` again.  `NuYieldException` run it's own versions of the `for` and `while`/`until` loops.


## A brief discussion on the Nu runtime

Nu is great as a Lisp-y language on top of the Cocoa/OpenStep frameworks.  It inherits a lot of Objective-C's introspection and adds a bit more.  However, there were many places where I was so close to having something elegant but Nu didn't quite provide it.  A lot of times, this got me thinking about how to extend Nu in such a way that it becomes it's own language for extending itself.

To a large extent, Nu is very flexible, especially with it's macro system.  However, for generators, I ran into issues of code context.  Once I'm inside a method, I didn't see a way to get a reference to it.  I couldn't put a bit of code in to see if I was in a for loop or get information about the currently executing block apart from its context.

The context provides the ability to really let the language know about itself.  Like Objective-C, there are already some hidden variables in the context.  What if Nu functions and blocks had a `_cmd` variable in their context?  What if `for` loops hid the implementation details in the context?  With a bit more introspection like this, objects like generators would be simple to code.

There's an additional complexity to adding these types of things and I'm not sure that the additional information would be truly utilized apart from creating generators.  However, the ability of a runtime to be able to stop and start code, throw execution contexts back and forth, or extend itself through contextual macros might open several interesting possibilities.

I am currently lacking in imagination apart from how generators would be more easily implemented, but I can imagine having a function that is broken into several parts.  The context of function may be the most
important part.  It may make more sense to do some action in one function, switch to another, then switch back to the first for more processing, and finally switch back to the second for cleanup.  Or there could be a macro that is used in several recursive functions.  Rather than re-write the macro for each function or add an argument to the macro, it could simply get `_cmd` as a reference to the enclosing function as a matter of convenience.  Finally, imagine working with some website API that throttled traffic.  Pulling data in a loop causes the client to be throttled.  Rather than breaking everything down and trying again later or even blocking the application until the throttle is lifted, the loop could be broken and added to a queue.  Later, at an idle moment of the application after the throttle limit has been reset, the loop can be continued right where it left off.

These are all examples of what could be done with a bit more introspection.  The Nu language itself could be written on the fly with some clever macros.  It adds to the complexity of the system and may not provide be worthwhile, but I would propose it as a consideration.


## Contact information

[Grayson Hansard](mailto:info@fromconcentratesoftware.com)  
[From Concentrate Software](http://fromconcentratesoftware.com/)




[nu]: http://programming.nu/