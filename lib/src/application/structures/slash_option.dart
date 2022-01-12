import 'package:nyxx/nyxx.dart' show ChannelType;

class SlashOption {
  SlashOptionType type;
  String name;
  String description;
  bool optionRequired;
  List<SlashOptionChoice>? choices;
  List<SlashOption>? options;
  List<ChannelType>? channelTypes;
  dynamic minValue;
  dynamic maxValue;
  bool autocomplete;


  SlashOption(this.type, this.name, this.description,
    {this.optionRequired = false, this.choices, this.options, this.channelTypes,
     this.minValue, this.maxValue, this.autocomplete = false});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "type": type.value,
      "name": name,
      "description": description,
      "required": optionRequired,
      "autcomplete": autocomplete
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

    if(channelTypes != null) {
      List<int> channelTypeList = [];
      channelTypes?.forEach((element) {
        channelTypeList.add(element.value);
      });

      data["channel_types"] = channelTypeList;
    }

    if(minValue != null) {
      data["min_value"] = minValue;
    }

    if(maxValue != null) {
      data["max_value"] = maxValue;
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
