# PoeApiStashSorter
Uses auto hotkey and the Path of Exile stash API to auto dump your mapping loot.

How it works:
First setup the script for your screen resulotion and PoE character.
Then run the script using autohotkey https://autohotkey.com/ (can run along side PoE Trade macro)
Then ingame open your stash, scroll to your 1st tab, normally currency.
Then press F6

This will connect to Path of exiles stash API and download the items currently in your inventory.
It will then Cntrl click each item and move to the next tab continuing to Cntrl click items.

This script assumes the following tabs in this (configurable) order;
"currency", "maps", "cards", "essence", "fragments", "TheRest"
Where "TheRest" is a dump tab.


Disclaimers:

Because this script performs more than one server action it's probably against GGG TOS. Use at own risk.
There is one limitation atm, the stash api has a 1-20 second delay, so sometimes the script misses some of the last items to enter your inventory. Under normal mapping this happens rarely for me.
I haven't configured fossils.
