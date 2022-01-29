# Onyx
Onyx is a barebones command handler for the Discord bot library [Nyxx](https://github.com/nyxx-discord/nyxx).

*Onyx is currently in development - features may be added or modified at any time.*

---
## Features
- **NyxxRest support** <br>
    Now you can separate the Gateway from your command functions!
- **Customizable command structure** <br>
    With simply a few elements required for a command, it is simple to extend the Command class and add as much as you want.
- **Common Text Converters** <br>
    Handle all those long ID and String conversions without all the code.
- **WIP - Slash Command Framework** <br>
    Create and sync slash commands, as simply or as powerfully as you wish.

# Usage
>**Key note:** *Onyx does not provide any way to automatically receive data.* <br>
What this means is that you will have to manually obtain and dispatch an event to a method within Onyx. This can be done using the gateway events, or any other custom solution via websockets, as long as Onyx is given the proper data.

Futher usage is to be defined.
