import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/transaction.dart';

class MovieDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, String directorname, String? filepat) onClickedDone;

  const MovieDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _MovieDialogState createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
    setState(() {
       if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.movieName!;
      amountController.text = transaction.directorname!;
      // isExpense = transaction.isExpense;
    }
    });

   
  }

  @override
  void dispose() {
    setState(() {
        nameController.dispose();
    amountController.dispose();
    });
  

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),
             
             // buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
         bulildGallaryButton(context),
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
    
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Movie Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
            
      );

  Widget buildAmount() => TextFormField(
        controller: amountController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Director Name',
        ),
        validator: (directorname) =>
            directorname != null && directorname.isEmpty ? 'Enter a valid name' : null,
      );

  // Widget buildRadioButtons() => Column(
  //       children: [
  //         RadioListTile<bool>(
  //           title: Text('Expense'),
  //           value: true,
  //           groupValue: isExpense,
  //           onChanged: (value) => setState(() => isExpense = value!),
  //         ),
  //         RadioListTile<bool>(
  //           title: Text('Income'),
  //           value: false,
  //           groupValue: isExpense,
  //           onChanged: (value) => setState(() => isExpense = value!),
  //         ),
  //       ],
  //     );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();
        setState(() {
           if (isValid) {
          final name = nameController.text;
          final directorname = amountController.text;
          final datetime=DateTime.now();

          widget.onClickedDone(name, directorname, imagepath);

          Navigator.of(context).pop();
        }
        });

       
      },
    );
  }
  String?  imagepath;
  final ImagePicker _picker = ImagePicker();


  void pickImageGallray()async{
    var image=await _picker.pickImage(source: ImageSource.gallery);

     imagepath=image!.path;
  }

 Widget bulildGallaryButton(BuildContext context) => TextButton(
        child: Text('Add Poster'),
        onPressed: () {
          setState(() {
            pickImageGallray();
          });
        },
      );
}
