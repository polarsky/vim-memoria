# Vim Memoria Plugin

Welcome to the vim-memoria plugin!

Keep track of your work and overall time with this companion tool.
Quickly format time alloction files ( `*ma` ) that are compatible
with gthomsen's
[time-allocations](https://github.com/gthomsen/time-allocations).
data analysis tool, which pulls out metrics about how much time
you work on certain things and where your time is going.

Here is an example of the ( `*ma` ) syntax:

```
Wednesday 1/9
# Comments look like this.
# [X] DONE: Get snacks
# [X] DONE: Eat snacks
# [X] DONE: Replenish snacks
# [_] TODO: Learn 2 Memoria
# [_] TODO: Work some development magic son

Snacks (chips (get)): 2.5 hours
Eat (snacks): .01 hours
Snacks (chips-soda (get)): 3.5 hours
vim-memoria : .25 hours
development (legit (work)): 1.5 hours

09:00-19:15 20:30-23:15 (13 hours)
```

# Installation

I recommend installing this plugin via Pathogen, which can be found at
[vim-pathogen](https://github.com/tpope/vim-pathogen), and follow
the next steps:

```sh
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone https://github.com/polarsky/vim-memoria.git
```

Then open vim and run Pathogen's `:Helptags` command to
generate tags for plugin documentation.
