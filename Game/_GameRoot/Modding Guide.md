# Welcome to Brilliant Depths! #

This is a guide for creating custom events within this game's framework. I will show how this can be done, from modifying an ingame event to creating your own. The first thing that must be understood is how to find the ingame events and understand its file structure. We will learn what an event group is and how they can be changed. From there, we will describe how to create an event. Along the way, we will show reveal how save data can be manipulated and utility methods. 

Before you get started, it is recommended that you have some understanding of Lua and Object Oriented programming, though I will do my best to explain its contents.

## File Structure ##
The moddable files are located in the same place that the game save files are located, the GameRoot.

*	Windows: C:\Users\user\AppData\Roaming\LOVE/Game
*	Mac: /Users/user/Library/Application Support/LOVE/Game
*	Linux: $XDG_DATA_HOME/love/Game

Inside here, you will find the GameRoot, potentially a save file, and probably a log file from the last run. Inside the GameRoot, you will find event_groups.csv and the Events directory. The Events directory contains all the .lua files which contain event data. event_groups.csv contains the event groups and which events are a part of them. We'll start with the event groups file.

### Event Groups ###
An event group is quite simply a group of events. The purpose of event groups are to allow for a certain amount of randomness, as when an event group is selected, a random one of the events that can be selected from that group is selected, and that event is the one that is displayed to the player. The file format is csv (comma seperated values). The first entry in a line is the name of the event group, and all subsequent entries in the line are the names of the events that are in that group. **Event names and event group can be any combination of letters, digits, spaces, and underscores.** Any other symbols will be treated as commas. To add or remove an eventgroup is simple as creating or deleting a line. Modifying events in event groups is equally simple: simply add the name of an event you want added or delete the name of an event you do not want in the group. 

If you want to see if there is a problem with the event groups, simply start the game, stop it, and check the log file. Warnings related to the Event Groups are displayed here.

### Event Files ###
Event files are located within the Events directory. Each file contains data related to the creation of Events. *File names have no inherent connection to the event(s) that are created inside them, although as a rule it is good to name the file the same thing or related to the event(s) created within.* New events are created through the creation of Events and Options objects.


## Event Objects ##
The Event class uses these functions:

*	Event.new(name) - Used to create a new Event object. It accepts a string, which is the event's name.
*	Event.can\_be\_chosen(self, game_data) - Used to determine if this event can be selected randomly from the event group. This is not called if this event is directly selected.
*	Event.get\_text(self, game_data) - Used to get the displayed text for the event. *You probably don't want to change the game data, only read it.*
*	Event.add_option(self, option) - Used to add an option to the event. 

It also has these, although you probably will not need them.

*	Event.get_options(self) - returns a list of all visible options. 
*	Event.get_name(self) - Used to get this event's name. 




## Option Objects ##
The option class uses these functions:

*	Option.new(text, should\_be\_visible) - Used to create a new option object. It accepts a string and a boolean. The string is the text the option will display, while should\_be\_visible is optional. This parameter determines if the option should be visible even if the option isn't selectable. It defaults to false.
*	Option.get\_text\_(self) - Returns the text of the option. 
*	Option.get\_next\_event\_name\_() - Returns the name of the next event, an event group to select the event from, or a subclass of Screen *You must implement this method!*
*	Option.selected\_action(self, game_data) - This is called when the option is selected. You will implement this out if you want any effects to occur, like reducing the player's food. 
*	Option.is\_selectable(self, game_data) - Is called to determine if the option is selectable i.e. can be clicked.

It also has these as part of the public interface, although you probably will not need them

*	Option.should\_be\_seen(self, game_data) - determines if the option can be seen, regardless if it can be clicked.


## Creating your own event ##
There are two major ways to create new events: The functional approach and the object oriented approach.

### The Functional Approach ###

###The Object Oriented Approach ###


## Using/changing save data ##
The save data is set up as a table. 
The table has these values:

*	randomseed - The randomseed of the game
*	inventory - this table stores the items in the table in the form of the item as a key and the amount of the item as the value
*	party - A table in list form which contains the players
*	event_data - A table which holds tables for specific events
*	currency - A number which is the amount of money the party has
*	misc - A table not designated to hold any particular data
*	day - A number which designates the day
*	depth - A number which states how many meters the party is at
*	layer - The numerical layer that you are on.
*	traveling_speed - A value which holds how fast the party is traveling
*	food\_consumption\_amount - A value which holds the amount of food being consumed

Of these, it is recommended that the modder only directly changes misc, currency, party, and inventory. Other functions exist that can safely affect the other fields.

#### Inventory ####
This stores items as a map of item name to amount of items. This table always returns 0 if the item is not present. It also has a method which should be used whenever you are setting the amount if an item.

*	inventory.changeItemAmount(self, item_name, changeAmount) - changes the amount of an item by the given number.

#### Party ####
The party is a list of the players. This means that when adding or removing a player, make sure that the list has no gaps (using table.insert / table.remove is good policy when changing this). Additionally, if creating a new party member, use the PartyMember class to do so. It's functions are: 

*	PartyMember.new(name, class) - Constructs a new pary member with a given name. Enter a class value from the enum PartyMember.Classes. Values are {Adventurer, Excavator, Hunter, Navigator, Crafter}.
*	PartyMember.getName(self) - Gets the name of the the party member.
*	PartyMember.getClass(self) - Gets the class of the party member. Value returned is of PartyMember.Classes.
*	PartyMember.getNumericHealthState(self) - Gets the healthstate of the player as a number from 0 to 100.
*	PartyMember.setNumericHealthState(self, value) - Sets the healthstate of the player. Must a a number. Is capped at 100 and floored at 0.
*	PartyMember.getHealthState(self) - Gets the healthstate. Value returned is a string. Potential values are {Great, Good, Fair, Poor}

Additionally, the party has some functions of its own.

*	party.getAverageHealth(self) - returns the average healthstate of the party. Returns it as a string of values {Great, Good, Fair, Poor}.
*	party.findPartyMembers(self, boolFunc) --Accepts a boolean function, which it applies to the party members as (boolFunc(party_member)). Returns a list which contains all party members that meet this criteria. Returns an empty list if none fit the criteria. 

#### Event Data ####
This table holds event data for specific events. The intention for this table is that each event will have a dedicated table for it. To get this table, use the given function. Events should not use this function to access the event data of another event. If you want to share data between events, try storing data in the misc table.

*	getEventSaveLocation(event, saveData) - Returns a table that can store data for the event



### Limitations of save data ###
Save data cannot properly store tables that have functions. You may have observed some tables in save data that has functions. These are exceptions to the rule, do not change such functions or attempt to store any functions in any tables of the save data. 

## Other API Functions ##
*	progress(save_data) - Used to progress the player's position, acts as the player
*	increaseDay(save_data) - Used to increment the day, processing all of the changes in food, health, etc
*	getLayer() - Returns information about the layer you are in based on the depth. Information is a table of the following format:
	*	depthMinimum - The minimum depth at which layer is.
	*	depthMaximum - The maximum depth at which the layer is.
	*	layerName - The namer of the layer. Current names are: {layer1, layer2, layer3, layer4, layer5}
