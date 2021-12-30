class SlashOption {
  SlashOptionType type;
  String name;
  String description;
  bool optionRequired;
  List<SlashOptionChoice>? choices;
  List<SlashOption>? options;
  List<int>? channelTypes;
  dynamic minValue;
  dynamic maxValue;
  bool autocomplete;


  SlashOption(this.type, this.name, this.description,
    {this.optionRequired = false, this.choices, this.options, this.channelTypes,
     this.minValue, this.maxValue, this.autocomplete = false});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "type": type.value,
      "required": optionRequired
    };

    if(choices != null) {
      List<Map<String, dynamic>> choiceList = [];
      choices?.forEach((choice) {
        choiceList.add(choice.toJson());
      });

      data["choices"] = choices;
    }

    if(options != null) {
      /// It should only go 3 deep for option.toJson() at most since the largest
      /// heirarchy would be: command -> sub group -> subcommand
      List<Map<String, dynamic>> optionsList = [];
      options?.forEach((option) {
        optionsList.add(option.toJson());
      });

      data["options"] = optionsList;
    }

    return data;
  }
}

class SlashOptionChoice<T extends String, int, double, bool> {
  String name;
  T value;

  SlashOptionChoice(this.name, this.value);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "type": value
    };
  }
}

enum SlashOptionType {
  subcommand,
  subcommandGroup,
  string,
  integer,
  boolean,
  user,
  channel,
  role,
  mentionable,
  number
}

extension SlashOptionValue on SlashOptionType {
  int get value {
    switch (this) {
      case SlashOptionType.subcommand:
        return 1;
      case SlashOptionType.subcommandGroup:
        return 2;
      case SlashOptionType.string:
        return 3;
      case SlashOptionType.integer:
        return 4;
      case SlashOptionType.boolean:
        return 5;
      case SlashOptionType.user:
        return 6;
      case SlashOptionType.channel:
        return 7;
      case SlashOptionType.role:
        return 8;
      case SlashOptionType.mentionable:
        return 9;
      case SlashOptionType.number:
        return 10;
    }
  }
}
