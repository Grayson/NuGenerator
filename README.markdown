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

## Contact information

[Grayson Hansard](mailto:info@fromconcentratesoftware.com)  
[From Concentrate Software](http://fromconcentratesoftware.com/)




[nu]: http://programming.nu/