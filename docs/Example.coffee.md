# Mather

Mather is a library for doing maths.

    var Mather = require('mather');
    var mather = new Mather();


## Add a placeholder assertion

Because there is some before-each code:

    var foo = "bar";

## Prune me

Because there are no assertions and no before-each code

```md
<!-- file: "some-file.md" -->
# Even if I have a file
```

## Adding

You can add two numbers:

    var result = mather.add(3, 4);
    expect(result).toEqual(7);

You can add more than two numbers

    var result = mather.add(3, 4, 5)
    expect(result).toEqual(12);

### Foo

    var foo = "bar";
    var bar = "baz";
    var mather = new Mather();

This is a thing

    expect(mather.add foo, bar).toEqual(2);

## Subtracting

You can subtract two numbers:

    var result = mather.subtract(4, 3);
    expect(result).toEqual(1);

You can subtract more than two numbers:

    var result = mather.subtract(4, 3, 2);
    expect(result).toEqual(-1);
