import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/repositories/endereco_repository.dart';
import 'package:infocep/utils.dart';

class BuscaField extends StatefulWidget {
  const BuscaField({ this.onSelected, super.key});

  final Function(Endereco endereco)? onSelected;

  @override
  State<BuscaField> createState() => _BuscaFieldState();
}

class _BuscaFieldState extends State<BuscaField> {

  Timer? _timer;
  final _options = <Endereco>[];

  _loadOptions(String busca) async {
    final res = await EnderecoRepository.buscaUnificada(busca);
    setState(() {
      _options.clear();
      if (res.type == ResultType.success) _options.addAll(res.data ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(64.0),
      ),
      child: Autocomplete<Endereco>(
        optionsBuilder: (textEditingValue) async {
          if (textEditingValue.text.length < 4) {
            return const Iterable.empty();
          }
          return _options;
        },
        optionsViewBuilder: (_, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 18.0),
              child: Material(
                elevation: 5.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 72,
                  height: 200.0,
                  child: ListView.separated(
                    itemCount: options.length,
                    itemBuilder: (__, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        visualDensity: VisualDensity.compact,
                        title: Text(option.subtitulo),
                        dense: true,
                        onTap: () => onSelected(option),
                      );
                    },
                    separatorBuilder: (__, index) => const Divider(height: 4.0),
                  ),
                ),
              ),
            ),
          );
        },
        displayStringForOption: (option) => option.porExtenso,
        onSelected: (option) {
          widget.onSelected?.call(option);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        fieldViewBuilder: (_, textEditingController, focusNode, onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onChanged: (s) {
              if (_timer != null) {
                _timer!.cancel();
              }
              _timer = Timer(const Duration(seconds: 1), () => _loadOptions(s));
              setState(() {});
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12.0, right: 8.0),
                child: Icon(Icons.search, size: 24.0),
              ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 24.0,
              ),
              suffixIcon: textEditingController.text.isNotEmpty ? IconButton(
                onPressed: () {
                  textEditingController.text = '';
                  setState(() {});
                },
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(0.0),
                icon: const Icon(Icons.close, size: 24.0),
              ) : null,
              hintText: 'CEP/Endereço',
            ),
            style: const TextStyle(fontSize: 20.0),
          );
        },
      ),
    );
  }
}