
The `ioc-*.adl` screens expect to receive two macros:

* `P` : the IOC prefix, including the trailing ":"
* `ioc` : the IOC prefix without the trailing ":"
  as needed for the screens supplied by iocStats.

Start MEDM like this:

```
medm  -macro "P=xxx:,ioc=xxx" -x ioc_motors.adl &
```
