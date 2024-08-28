import 'dart:io';
import 'package:flutter/material.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'google_sheets_service.dart';


// Global variables to store scanned images and the scan count
File? frontID;
File? backID;
String? selectedArea;
String? selectedCity;


int scanCount = 0;

class FrontImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: frontID != null
              ? Image.file(frontID!)  // Display the image using Image.file
              : Text('No image selected'),  // Fallback if no image is available
        ),
      ),
    );
  }
}

class BackImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: backID != null
              ? Image.file(backID!)  // Display the image using Image.file
              : Text('No image selected'),  // Fallback if no image is available
        ),
      ),
    );
  }
}


class ScannerLogic extends StatefulWidget{
  @override
  _ScannerLogic  createState() => _ScannerLogic();

}
class _ScannerLogic extends State<ScannerLogic> {
  void _startScan(BuildContext context) async {
    var image = await DocumentScannerFlutter.launch(context);
    if (image != null) {
      setState(() {
        // Update the global variable depending on the current scan count
        if (scanCount == 0) {
          frontID = image;
        } else if (scanCount == 1) {
          backID = image;
        }

        scanCount++;

        // Check if we need to navigate to the new page after 2 scans
        if (scanCount >= 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScannerLogic()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            frontID == null
                ? Text('No first document scanned yet.')
                : Image.file(frontID!),
            SizedBox(height: 10),
            backID == null
                ? Text('No second document scanned yet.')
                : Image.file(backID!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startScan(context),
              style: ElevatedButton.styleFrom(
                backgroundColor : Color.fromARGB(255, 107, 125, 139)
              ),
              child: Text('Scan Document',
              style: TextStyle(
                color : Colors.white,
              ),),
            ),
            SizedBox(height:10),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()), 
        );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor : Color.fromARGB(255, 30, 126, 204)
              ),
              child: Text('Next',
              style: TextStyle(
                color : Colors.white,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}

class GlobalControllers{

  static final firstNameController = TextEditingController();
  static final lastNameController = TextEditingController();

  static final emailController = TextEditingController();
  static final mobileNumberController = TextEditingController();
  static final landlineController = TextEditingController();

  static final apartmentController = TextEditingController();
  static final buildingController = TextEditingController();
  static final floorController = TextEditingController();

  static final streetNameController = TextEditingController();
  static final landmarkController = TextEditingController();
}
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;

  StepProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the Row on the main axis
        mainAxisSize: MainAxisSize.min, // Shrink-wrap the row around its children
        children: List.generate(3, (index) {
          return Row(
            mainAxisSize: MainAxisSize.min, // Ensure the inner Row is as small as needed
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade500,
                radius: 15,
                child: CircleAvatar(
                  backgroundColor: (index + 1) <= currentStep
                      ? const Color.fromARGB(255, 30, 126, 204)
                      : Colors.white,
                  radius: 14,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: (index + 1) <= currentStep
                          ? Colors.white
                          : Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (index < 2)
                SizedBox(
                  width: 80, // Set the desired space between the circles
                  child: Divider(
                    color: (index + 1) < currentStep
                        ? Color.fromARGB(255, 30, 126, 204)
                        : Colors.grey.shade400,
                    thickness: 3,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
class CreateAccountPage extends StatefulWidget{
  @override
  _CreateAccountPage  createState() => _CreateAccountPage();
}
class _CreateAccountPage extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
        style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26, // Make the text bold
  ),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
        key:_formKey,
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepProgressIndicator(currentStep: 1),
            SizedBox(height: 15),
            Text(
              'Welcome! Let\'s get started by gathering some basic information about you. Please fill out the following fields',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Center(
                 child: SizedBox(
                  width: 600, 
                  child: TextFormField(
                  controller: GlobalControllers.firstNameController,
                  decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
             ),
            ),
            
            SizedBox(height: 20),
            Center(
                 child: SizedBox(
                  width: 600, // Set the desired width for the TextFormField
                  child: TextFormField(
                  controller: GlobalControllers.lastNameController,
                  decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
             ),
            ),
            
            SizedBox(height: 20),
            Center(
                 child: SizedBox(
                  width: 600, // Set the desired width for the TextFormField
                  child: TextFormField(
                  controller: GlobalControllers.mobileNumberController,
                  decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter your Mobile Number';
                  }
                  return null;
                },
              ),
             ),
            ),
            
            SizedBox(height: 20),
            Center(
                 child: SizedBox(
                  width: 600, // Set the desired width for the TextFormField
                  child: TextFormField(
                  controller:GlobalControllers.landlineController,  
                  decoration: InputDecoration(
                  labelText: 'Landline',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter your landline';
                  }
                  return null;
                },
              ),
             ),
            ),
            
            SizedBox(height: 20),
            Center(
                 child: SizedBox(
                  width: 600, // Set the desired width for the TextFormField
                  child: TextFormField(
                  controller : GlobalControllers.emailController,  
                  decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter your email';
                  }
                  // Regular expression for validating an email
              String pattern =
                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
                  return null;
                },
              ),
             ),
            ),
            SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
            Spacer(),
            Center(
    child: SizedBox(
    width: 220, // Set the desired width for the button
    height: 40, // Set the desired height for the button
    child: ElevatedButton(
      onPressed: () {
        if(_formKey.currentState!.validate()){
          setState(() {
            _errorMessage ="";
          });
          // Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddressPage()), // Replace with your next page
        );
        } else{
          _errorMessage = 'Please fill in all required fields';
        }
        
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 30, 126, 204),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Next',
        style: TextStyle(fontSize: 18,
        color: Colors.white),
      ),
    ),
  ),
),
Spacer(),

          ],
        ),
        ),
      ),
    );
  }
}
class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}
class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  final List<String> areas = ['Cairo', 'Alexandria','Giza','Luxor','Aswan','Port Said',
'Mansoura','Tanta','Faiyum','Minya','Sohag','Others'];
  final Map<String, List<String>> cities = {
    'Cairo': ['Nasr City', 'Heliopolis', 'Maadi' ,'Zamalek','Downtown Cairo' , 'Garden City' ,'New Cairo'],
    'Alexandria': ['Montazah', 'Sidi Gaber', 'Smouha','Roushdy','Gleem','Stanley'],
    'Giza':['Dokki','Mohandessin','Haram','6th of October','El Sheikh Zayed'],
    'Luxor':['East Bank','West Bank','Karnak'],
    'Aswan':['Elephantine Island','Agouza','West Aswan'],
    'Port Said':['El Shuhada','El Salam'],
    'Mansoura':['Talkha','Gamaa','El Mashaya'],
    'Tanta':['El Bosta','El Sayeda Zeinab','El Gharbia'],
    'Faiyum':['Faiyum City Center','Medinet Madi','Tunis Village','Qarun Lake Area'],
    'Minya':['Minya City Center','New Minya'],
    'Sohag':['Sohag City Center','Akhmim','El Gharb'], 
    'Others':['Others'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
        style:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),),
        leading: BackButton(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
        key:_formKey,
        child : Column(
          crossAxisAlignment : CrossAxisAlignment.start,
          
          children: [
            StepProgressIndicator(currentStep: 2),
            Spacer(),
            Row(
  children: [
    
    SizedBox(height:70),
    Expanded(
      child : Center(
        child: SizedBox(
          width:200,
          child : TextFormField(
          controller: GlobalControllers.apartmentController,
          decoration: InputDecoration(
            labelText: 'Apartment',
            labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
          ),
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Please enter your apartment number';
            }
            return null;
          },
          ),
      ),
      )
      
    ),
    SizedBox(width: 10), 
    Expanded(
      child : Center(
        child: SizedBox(
          width:200,
          child : TextFormField(
          controller: GlobalControllers.floorController,
          decoration: InputDecoration(
            labelText: 'Floor',
            labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
          ),
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Please enter your floor number';
            }
            return null;
          },
          ),
      ),
      )
      
    ),
    SizedBox(width: 10), 
    Expanded(
      child : Center(
        child: SizedBox(
          width:200,
          child : TextFormField(
          controller: GlobalControllers.buildingController,
          decoration: InputDecoration(
            labelText: 'Building',
            labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
          ),
          validator: (value){
            if(value == null || value.isEmpty){
              return 'Please enter your building number';
            }
            return null;
          },
          ),
      ),
      )
      
    ),
  ],
),
SizedBox(height: 15),
            Center(
                 child: SizedBox(
                  width: 600, 
                  child: TextFormField(
                  controller: GlobalControllers.streetNameController,
                  decoration: InputDecoration(
                  labelText: 'Street Number',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'Please enter your Street Number';
                  }
                  return null;
                },
              ),
             ),
            ),

            
            Row(children: [
              SizedBox(height:80),
              Expanded(
                child:Center(child: SizedBox(
                  width: 300,
                  child:DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Area',labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),),
              value: selectedArea,
              items: areas.map((String area) {
                return DropdownMenuItem<String>(
                  value: area,
                  child: Text(area),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedArea = newValue;
                  selectedCity = null; 
                });
              },
            ),
                ),
                ),
                
              ),
              SizedBox(width: 10), 
              Expanded(
                child:Center(child: SizedBox(

                width : 300,
                
                child : DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'City',labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),),
              value: selectedCity,
              items: selectedArea == null
                  ? []
                  : cities[selectedArea]!.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
            ),
            ),),
              ),
            ],),
            SizedBox(height: 15),
            Center(
                 child: SizedBox(
                  width: 600,
                  child: TextFormField(
                  controller: GlobalControllers.landmarkController,
                  decoration: InputDecoration(
                  labelText: 'Landmark',
                  labelStyle: TextStyle(
                         color:  Colors.grey.shade800, 
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade800), 
                  ),
                ),
                
              ),
             ),
            ),
            
            Spacer(),
            Spacer(),
            Spacer(),
            Spacer(),
            Center(
    child: SizedBox(
    width: 220, 
    height: 40, 
    child: ElevatedButton(
      onPressed: () {
        if(_formKey.currentState!.validate()){
          setState(() {
            _errorMessage ="";
          });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScannerLogic()), 
        );
        } else{
          _errorMessage = 'Please fill in all required fields';
        }
        
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 30, 126, 204),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Next',
        style: TextStyle(fontSize: 18,
        color: Colors.white),
      ),
    ),
  ),
),
Spacer(),
          ],
        ),
      ),
      ),
    );
  }
}
class RegisterPage extends StatelessWidget {
  final GoogleSheetsService _googleSheetsService = GoogleSheetsService();
  
  Future<void> _submitData() async {
    
    // Define folder and spreadsheet IDs
    final folderId = '1uD-8E7gKZe8mwNi3W4K32a_VBW0NPdmV';
    final fullname = GlobalControllers.firstNameController.text + " " + GlobalControllers.lastNameController.text;
    final address = GlobalControllers.buildingController.text +" " + GlobalControllers.streetNameController.text +" Street." + " " + selectedArea.toString() +"," +" "+selectedCity.toString()+" " + "Floor "+GlobalControllers.floorController.text+" "+"Apartment "+GlobalControllers.apartmentController.text+" " + GlobalControllers.landmarkController.text;
    final imageName1 = fullname + ' front_id.jpg'; 
    final imageName2 = fullname + ' back_id.jpg'; 
    
    final data = [
      ['Full Name', 'Phone Numbers', 'Landline', 'Email Address', 'Home Address' , 'front_id' , 'back_id'],
      [
        fullname,
        GlobalControllers.mobileNumberController.text,
        GlobalControllers.landlineController.text,
        GlobalControllers.emailController.text,
        address,
        imageName1,
        imageName2
      ],
    ];

    final assetPath = 'assets/images/front_id.jpg';
    

    // Replace 'your_spreadsheet_id' with your Google Sheet ID and 'Sheet1!A1' with the desired range
    await _googleSheetsService.insertData(
      data,
      '1pVVJlhDBWiV2gUVQ7VvfZGrAiWYItml576wUa-zSfLY',
      'Sheet1!A1',
    );
    GlobalControllers.firstNameController.clear();
    GlobalControllers.lastNameController.clear();
    GlobalControllers.emailController.clear();
    GlobalControllers.streetNameController.clear();
    GlobalControllers.landlineController.clear();
    GlobalControllers.mobileNumberController.clear();
    GlobalControllers.apartmentController.clear();
    GlobalControllers.buildingController.clear();
    GlobalControllers.floorController.clear();
    GlobalControllers.landmarkController.clear();

    selectedArea = null;
    selectedCity = null;
    frontID = null;
    backID = null;
    await _googleSheetsService.uploadImage(frontID, folderId, imageName1);
    await _googleSheetsService.uploadImage(backID, folderId, imageName2);

  }
  @override
  Widget build(BuildContext context) {
    final fullname = GlobalControllers.firstNameController.text + " " + GlobalControllers.lastNameController.text;
    final address = GlobalControllers.buildingController.text +" " + GlobalControllers.streetNameController.text +" Street."+ " " + selectedArea.toString() +"," +" "+selectedCity.toString()+" " + "Floor "+GlobalControllers.floorController.text+" "+"Apartment "+GlobalControllers.apartmentController.text +" " + GlobalControllers.landmarkController.text;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),),
        leading: BackButton(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
      child : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepProgressIndicator(currentStep: 3),
            //Spacer(),
            SizedBox(height: 25),
            buildTextField('FULL NAME', fullname,  Icons.person),
            SizedBox(height: 25),
            buildTextField('PHONE NUMBERS', GlobalControllers.mobileNumberController.text,  Icons.phone),
            SizedBox(height: 10),
            buildPhoneField(GlobalControllers.landlineController.text),
            SizedBox(height: 25,),
            buildTextField('EMAIL ADDRESS', GlobalControllers.emailController.text, Icons.alternate_email),
            SizedBox(height: 25),
            buildAddressField('HOME ADDRESS', address,  Icons.location_pin),
            SizedBox(height: 25),
            buildNationalIdField(context), 
            SizedBox(height: 25),
            Center(
              child : SizedBox(
                width: 220,
                height : 40,
              child: ElevatedButton(
                onPressed: () async{
                  await _submitData();
                  Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationPage()), 
        );
                },
                style : ElevatedButton.styleFrom(
                  backgroundColor:  Color.fromARGB(255, 30, 126, 204),
                  shape : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )
                ),
                child: Text('Submit',
                style : TextStyle(fontSize : 18,
                color : Colors.white)),
                
              ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget buildAddressField(String label,  String hint,  IconData icon){
    int maxLines = 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
          ],
        ),
        
        SizedBox(height: 4),
        Center(
          child: SizedBox(
            width:600,
            height : 50,
            child : TextField( 
              maxLines: maxLines,
          readOnly: true, 
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            filled: true,
            fillColor: const Color.fromARGB(85, 96, 125, 139),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),

            )
          ),
        
      ],
    );
  }

  Widget buildPhoneField(String hint){
    int maxLines = 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 6),
        Center(
          child: SizedBox(
            width:600,
            height : 35,
            child : TextField(
          maxLines: maxLines,   
          readOnly: true, 
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            filled: true,
            fillColor: const Color.fromARGB(85, 96, 125, 139),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
            )
          ),
      ],
    );
  } 
  Widget buildTextField(String label,  String hint,  IconData icon) {
    int maxLines = 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 7),
        Text(label, style: TextStyle(fontSize: 14,  color: Colors.grey.shade700)),
          ],
        ),
        
        SizedBox(height: 6),
        Center(
          child: SizedBox(
            width:600,
            height : 35,
            child : TextField(   
          readOnly: true, 
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black,
            ),
            filled: true,
            fillColor: const Color.fromARGB(85, 96, 125, 139),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),

            )
          ),
        
      ],
    );
  }

  Widget buildNationalIdField(BuildContext context) {
  return Column(
    
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.image, color: Colors.black),
          SizedBox(width: 6),
          Text(
            "NATIONAL ID",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
      SizedBox(height: 8),  
      Center(
        
        child:SizedBox(
          width: 600,
          height:50,
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FrontImagePage()),
            );
          },
          child: Align(
  alignment: Alignment.centerLeft,
  child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, 
            children: [
              Icon(Icons.image, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Front Id',
                style: TextStyle(
                  color: Colors.blueAccent, 
                  decoration: TextDecoration.underline, 
                  decorationColor: Colors.blueAccent
                ),
              ),
            ],
          ),
            ),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(85, 96, 125, 139),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, 
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          ),
        ),
      ),
      ),
      SizedBox(height: 8),  
      Center(
        child:SizedBox(
          width: 600,
          height : 50,
          child: OutlinedButton(
          onPressed: () {
             Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FrontImagePage()),
            );
          },
          child: Align(
  alignment: Alignment.centerLeft,
  child:Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Icon(Icons.image, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Back Id',
                style: TextStyle(
                  color: Colors.blueAccent, 
                  decoration: TextDecoration.underline, 
                  decorationColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
            ),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color.fromARGB(85, 96, 125, 139),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, 
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          ),
        ),
        ),
      ),
    ],
  );
}

}
class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 300, 
          height: 400, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Registration Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Congratulations! You have successfully completed the registration process. Your profile is now set up, and now you can start exploring all features and benefits we offer.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccountPage()),
                  );
                },
                child: Text('Register Another User',
                style: TextStyle(
                  color: Colors.white,
                ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor : Color.fromARGB(255, 30, 126, 204),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: CreateAccountPage(),
  ));
}

