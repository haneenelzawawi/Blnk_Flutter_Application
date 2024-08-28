# Blnk_Flutter_Application

## Overview
This Flutter application collects basic user information and scans the front and back of a national ID card using the camera. The app processes the scanned images to find the contour and extracts the ID card. All collected information and processed images are then stored on Google Drive and documented in a Google Spreadsheet.

### Features

- Collect basic user information:
  - First Name.
  - Last Name.
  - Detailed Address.
  - Landline.
  - Mobile.
  - National ID.

- Scan the front and back of the National ID card using the device's camera.
- Find contours of the scanned images and extract the ID card.
- Submit all information and store it on Google Drive.
  - Basic information is stored in a Google Spreadsheet.
  - Images are stored in a Google Drive folder, with filenames listed in the spreadsheet.

### Installation

1. Clone the repository
   ``` git clone https://github.com/yourusername/your-repository.git ```
   ``` cd your-repository ```

2. Install dependencies
   ``` flutter pub get ```
4. Set up Google APIs
- Either by enabling Google Drive and Google Sheets APIs in the Google Cloud Console.
- By using the json file in the \assets
    - Link for google sheets : https://docs.google.com/spreadsheets/d/1pVVJlhDBWiV2gUVQ7VvfZGrAiWYItml576wUa-zSfLY/edit?gid=0#gid=0
    - Link for google drive : https://drive.google.com/drive/folders/1uD-8E7gKZe8mwNi3W4K32a_VBW0NPdmV?usp=sharing
 
### Running the App 
``` flutter run ```

## Technologies Used

This project utilizes the following technologies:

- **Flutter**: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Dart**: A programming language optimized for building fast, scalable applications.
- **Google APIs**:
  - **Google Drive API**: For storing user-uploaded images.
  - **Google Sheets API**: For storing and managing user information in a spreadsheet.
- **Git**: Version control system for tracking changes in the source code.
- **Markdown**: For writing documentation and README files.



