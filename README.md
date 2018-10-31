# PoeApiStashSorter
Use auto hotkey and Path of Exiles stash API to auto dump your mapping loot

How it works:
First setting up the script for your screen res and PoE character.
Then run the script using autohotkey https://autohotkey.com/
Then ingame open your stash, scroll to your 1st tab normally currency.
Then press F6

This will connect to Path of exiles stash API and download the items currently in your inventory.
It will then Cntrl click each item and move to the next tab continuing to Cntrl click items.

The normal setup would be the following tabs in this (configurable) order
"currency", "maps", "cards", "essence", "fragments", "TheRest"
Where "TheRest" is a dump tab.


Disclaimers:

Because this script performs more than one server actions its probably against GGG TOS. Use at own risk.
There is one limitation atm, the stash api has a 1-30 second delay, so sometimes the script misses some of the last items to enter your inventory. Under normal mapping this happens rarely for me.
I haven't configured for fossils.
