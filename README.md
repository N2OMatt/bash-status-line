bash-status-line
====

**tl;dr**

A naive implementation of terminal status line, licensed as GPLv3 <3.

Please checkout (**Inspiration** and **License**).

<!-- ####################################################################### -->
<!-- ####################################################################### -->

## Intro

<!-- COWTODO: -->


<!-- ####################################################################### -->
<!-- ####################################################################### -->

## Features

<!-- COWTODO: -->

<!-- ####################################################################### -->
<!-- ####################################################################### -->

## Motivation

<!-- COWTODO: -->


<!-- ####################################################################### -->
<!-- ####################################################################### -->

## Inspiration

* Artem Nistratov (ADone)'s : [bash-status-line](https://github.com/ADone/bash-status-line)   
I started using his code, but I found that it wasn't what I needed/wanted - But
I took a lot from his code - Mostly the ```bslrc.sh``` logic (Was very interesting 
to learn the relationship about ```PROMPT_COMMAND``` var and the status-line refresh) 
and the ```tput(1)``` stuff located originally on his ```bsl_setter.sh```.

* Bruno Adele (badele)'s : [gitcheck](https://github.com/badele/gitcheck)    
I'm a _"power-user"_ of his ```gitcheck``` tool - I think that is very, very 
util and I poked his code a lot (```pdb.set_trace + s + p VARNAME``` FTW). While
I didn't grabbed anything directly from ```gitcheck```, it was a invaluable tool 
to me to learn the how the several ```git(1)``` commands are created.


<!-- ####################################################################### -->
<!-- ####################################################################### -->

## Usage

Just ```source``` the ```n2orc.sh``` - This usually is enough, but it might 
not be what you really want.

Doing this you'll find that the ```bash(1)``` readline library interprets the 
```C-l``` in a way that doesn't plays nice with the ```bash-status-line```.

Fix this is actually easy thing to do so:

* Just add this line in your ```bashrc``` or ```bash_profile``` file.   
```bash
    bind -x '"\C-l":clear; $PROMPT_COMMAND';
```    
OR    
* Uncomment the very same line on ```n2orc.sh``` (I added it for the people that 
don't want messy with the ```bashrc```).

This will **override** the default behavior of the ```C-l``` in bash, but with 
the same results - namely it will clear the screen and force the ```bash-status-line```
to be redraw.



<!-- ####################################################################### -->
<!-- ####################################################################### -->

## License

GPLv3 as usual <3

**Notice** - While I took a lot from 
(ADone)'s [bash-status-line](https://github.com/ADone/bash-status-line) and 
I don't **really** know if I must release the software with the same 
license from his license (MIT).   
I surely learn a lot from his code - Thanks ADone - but implemented everything,
but some bits of code, by myself from zero.    
Well, I'm trying to play **nice**, giving the credits and all the stuff, but 
I'm **NOT** a lawyer - So if I **MUST** license equally from him, I'll sure 
do so.

I'm not a stealer or an asshole (just ignorant in some respects ;D) - So please
if I'm doing something wrong here **TELL ME**.


<!-- ####################################################################### -->
<!-- ####################################################################### -->

## Others

Check out :

* My opensource stuff at [www.github.com/n2omatt](http://www.github.com/n2omatt).
* My site at [n2omatt.com](http://www.n2omatt.com).
* Amazing Cow's opensource stuff 
[opensource.amazingcow.com](http://opensource.amazingcow.com) - A lot of stuff (**really**).
* Amazing Cow's site [amazingcow.com](http://www.amazingcow.com).


