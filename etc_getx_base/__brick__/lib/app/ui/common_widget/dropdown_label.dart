import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:{{project_route}}/app/utils/app_colors.dart';

class DropdownModel<T> {
  final String title;
  final T value;
  DropdownModel({
    this.title,
    this.value,
  });
}

class DropdownLabel<T> extends StatefulWidget {
  final String label;
  final List<DropdownModel<T>> list;
  final T value;
  final bool complusoryIndicator;
  final bool enabled;
  final Function(T) onChanged;

  const DropdownLabel(
    this.label,
    this.list, {
    this.value,
    this.complusoryIndicator = false,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<DropdownLabel<T>> createState() => _DropdownLabelState<T>();
}

class _DropdownLabelState<T> extends State<DropdownLabel<T>> {
  List<DropdownMenuItem<T>> dropdownList = [];
  T _selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.value != null) {
      _selectedValue = widget.value;
    }
  }

  formatDropdown() {
    dropdownList.clear();
    for (var item in widget.list) {
      dropdownList.add(DropdownMenuItem(
        child: Text(item.title),
        value: item.value,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    formatDropdown();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        (widget.complusoryIndicator)
            ? Text.rich(TextSpan(
                text: widget.label,
                style: const TextStyle(color: colorBlack, fontSize: 14),
                children: const [
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: colorBlack),
                    ),
                  ]))
            : Text(
                widget.label,
                style: const TextStyle(color: colorBlack, fontSize: 14),
              ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<T>(
              value: (dropdownList.isEmpty) ? null : _selectedValue,
              items: dropdownList,
              dropdownMaxHeight: kMinInteractiveDimension * 5,
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: colorBlack,
              ),
              buttonPadding: const EdgeInsets.symmetric(horizontal: 20),
              style: const TextStyle(
                color: colorBlack,
                fontSize: 16,
              ),
              onChanged: (widget.enabled)
                  ? (value) {
                      if (widget.onChanged != null) {
                        widget.onChanged(value);
                      }
                      setState(() {
                        _selectedValue = value;
                      });
                    }
                  : null,
              iconEnabledColor: colorBlack,
              iconSize: 30,
              dropdownDecoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
      ],
    );
  }
}
