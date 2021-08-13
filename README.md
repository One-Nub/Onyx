# Onyx
Onyx is a barebones command handler for the Discord bot library [Nyxx](https://github.com/l7ssha/nyxx).

*Onyx is currently in development - features may be added or modified at any time.*

---
## Features
- **NyxxRest support** <br>
    Now you can separate the Gateway from your command functions!
- **Customizable command structure** <br>
    With simply a few elements required for a command, it is simple to extend the Command class and add as much as you want.
- **Common Converters** <br>
    Handle all those long ID and String conversions without all the code.
- **WIP - Slash Command Framework** <br>
    Create and sync slash commands, as simply or as powerfully as you wish.

---
## Why make Onyx?
The built in command handler for Nyxx (known as [Commander](https://github.com/l7ssha/nyxx/tree/dev/nyxx_commander)) works great but it presents itself with some unclear methods for creating and handling commands, subcommands, and command groups in my opinion. (Although I may have figured out how they work when making this - but it's too late to turn back now)

Futhermore, Nyxx's Commander does not support the NyxxRest client at all which makes it difficult to separate the Gateway and the command functionality from each other - which can be a concern for large bot growth where someone may want to separate the command functionality and gateway.

Finally, I made this just for a project to do, because programming is neat.


# Usage
>**Key note:** *Onyx does not provide any way to automatically receive data.* <br>
What this means is that you will have to manually obtain and dispatch an event to a method within Onyx. This can be done using the gateway events, or any other custom solution, as long as Onyx is given the proper data.

Futher usage is to be defined.
