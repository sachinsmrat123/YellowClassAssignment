import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/transaction.dart';
/**
 * this class is basically for taking the user input
 */
class MovieDialog extends StatefulWidget {
  final Transaction? transaction;
  //this function will be responsible for passing the fields
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
  //taking the reference of key for state management
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
    //checking wether user have to add or update
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
              buildDirectorName(),
              SizedBox(height: 8),
             
             
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

  Widget buildDirectorName() => TextFormField(
        controller: amountController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Director Name',
        ),
        validator: (directorname) =>
            directorname != null && directorname.isEmpty ? 'Enter a valid name' : null,
      );

 

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';
//if some data is already there then it will be updated
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
  //storing path
  String?  imagepath;
  final ImagePicker _picker = ImagePicker();

/**
 * picking image from gallry
 */
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
