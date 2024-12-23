import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/widgets/pdf_generator.dart';

import 'package:tmkt3_app/features/home/widgets/custom_drawer.dart';

class GenericListScreen extends StatefulWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final VoidCallback? onAdd;
  final VoidCallback? onExport;

  final TextEditingController searchController;

  const GenericListScreen({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
    this.onAdd,
    this.onExport,
    required this.searchController,
  });

  @override
  State<GenericListScreen> createState() => _GenericListScreenState();
}

class _GenericListScreenState extends State<GenericListScreen> {
  int _currentPage = 0;
  final int _rowsPerPage = 6;

  List<DataRow> get _paginatedRows {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, widget.rows.length);
    return widget.rows.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Image.asset(
              "assets/images/logo_principal.png",
              width: 60,
            ),
            Text("IEP. Santa Maria School", style: textTheme.labelLarge),
            SizedBox(width: 20),
          ],
        ),
      ),
      body: Container(
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.12, vertical: 60),
        padding: EdgeInsets.all(60),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.onAdd != null)
                    SizedBox(
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: widget.onAdd,
                        label: Text("Registrar"),
                        icon: Icon(Icons.add),
                      ),
                    ),
                  SizedBox(width: 12),
                  if (widget.onExport != null)
                    SizedBox(
                      height: 45,
                      child: FilledButton.icon(
                        onPressed: () async {
                          print(
                              "Exportingsasda PDF ${widget.columns[0].label}");
                          print(
                              "Exporting PDF ${widget.rows[0].cells[0].child}");
                          await exportToPdf(
                            title: widget.title,
                            columns: widget.columns,
                            rows: widget.rows,
                          );
                        },
                        label: Text("Exportar PDF"),
                        icon: Icon(Icons.picture_as_pdf),
                      ),
                    ),
                  Spacer(),
                  Expanded(
                    child: TextFormField(
                      controller: widget.searchController,
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Text("Datos", style: textTheme.headlineMedium),
              SizedBox(height: 12),
              Expanded(
                child: SizedBox(
                  width: size.width,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(218, 219, 87, 35)),
                    dataRowColor: WidgetStateProperty.resolveWith((states) =>
                        states.contains(WidgetState.selected)
                            ? Colors.orange
                            : Colors.white),
                    dividerThickness: 0.3,
                    columnSpacing: 15.0,
                    dataTextStyle: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                    headingTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    showCheckboxColumn: false,
                    columns: widget.columns,
                    rows: _paginatedRows,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _currentPage > 0
                          ? () => setState(() => _currentPage--)
                          : null,
                    ),
                    Text(
                        'Página ${_currentPage + 1} de ${(widget.rows.length / _rowsPerPage).ceil()}'),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed:
                          (_currentPage + 1) * _rowsPerPage < widget.rows.length
                              ? () {
                                  setState(() => _currentPage++);
                                }
                              : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
