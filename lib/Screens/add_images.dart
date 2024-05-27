import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morched/constants/constants.dart';

class AddMarketImages extends StatefulWidget {
  const AddMarketImages({super.key});

  @override
  State<AddMarketImages> createState() => _AddMarketImagesState();
}

class _AddMarketImagesState extends State<AddMarketImages> {
  io.File? image;
  String? imageURL;
  io.File? registreCommerceImage;

  List<io.File> selectedImages = [];

  Future<void> getRegistreCommerceImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = io.File(image.path);

      // Update the registreCommerceImage variable in the state
      setState(() {
        registreCommerceImage = imageTemp;
      });

      // Upload the selected image to Firebase Storage
      String? registreCommerceImageUrl = await uploadImage(imageTemp);
      // Save the registre commerce image URL to Firestore
      await saveUserData(null, [], registreCommerceImageUrl);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> uploadImage(io.File imageFile) async {
    try {
      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to the location where you want to store the image in Firebase Storage
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$fileName');

      // Upload the file to Firebase Storage
      firebase_storage.UploadTask uploadTask = reference.putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadURL = await (await uploadTask).ref.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (e) {
      print('Failed to upload image: $e');
      rethrow; // Rethrow the exception
    }
  }

  Future<void> saveUserData(String? profileImageUrl, List<String> imageUrls,
      [String? registreCommerceImageUrl]) async {
    try {
      // Get the current logged user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Update the user document in Firestore with the profile image URL, image URLs, and registre commerce image URL
      Map<String, dynamic> userData = {
        'imageUrls': imageUrls,
      };

      if (profileImageUrl != null) {
        userData['profileImageUrl'] = profileImageUrl;
      }

      if (registreCommerceImageUrl != null) {
        userData['registreCommerceImageUrl'] = registreCommerceImageUrl;
      }

      await FirebaseFirestore.instance
          .collection('normal_users')
          .doc(user.uid)
          .update(userData);
    } catch (e) {
      print('Failed to save user data: $e');
    }
  }

  // Modify getProfileImage function to upload image to Firebase Storage
  Future<void> getProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = io.File(image.path);

      // Update the image variable in the state
      setState(() {
        this.image = imageTemp;
      });

      // Upload the selected image to Firebase Storage
      String? profileImageUrl = await uploadImage(imageTemp);
      // Save the profile image URL to Firestore
      await saveUserData(profileImageUrl, []);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Modify getImages function to upload images to Firebase Storage
  Future<void> getImages() async {
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage();
      setState(() {
        selectedImages.clear();
        selectedImages.addAll(images.map((XFile image) => io.File(image.path)));
      });

      List<String> imageUrls = [];

      // Upload each selected image to Firebase Storage
      for (io.File imageFile in selectedImages) {
        String? imageUrl = await uploadImage(imageFile);
        imageUrls.add(imageUrl);
      }

      // Save the image URLs to Firestore
      if (imageUrls.isNotEmpty) {
        await saveUserData(null, imageUrls);
      }
    } on PlatformException catch (e) {
      print('Failed to pick images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(120, 255, 175, 55),
                  Color.fromARGB(120, 180, 87, 173),
                  Color.fromARGB(120, 255, 87, 199),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Ajouter Votre Photo de Profile:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: getProfileImage,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: image != null
                          ? ClipOval(
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90000),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Ajouter les Images de votre Service:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: selectedImages.isNotEmpty
                      ? SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 110,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Image.file(
                                      selectedImages[index],
                                      fit: BoxFit.fill,
                                    )),
                              );
                            },
                          ),
                        )
                      : GestureDetector(
                          onTap: getImages,
                          child: Container(
                            height: 120,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child:
                                const Icon(Icons.add_photo_alternate, size: 50),
                          ),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Ajouter l'image de votre registre commerce",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: selectedImages.isNotEmpty
                      ? SizedBox(
                          height: 120,
                          width: 250,
                          child: Image.file(
                            registreCommerceImage!,
                            fit: BoxFit.fitWidth,
                          ))
                      : GestureDetector(
                          onTap: getRegistreCommerceImage,
                          child: Container(
                            height: 120,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child:
                                const Icon(Icons.add_photo_alternate, size: 50),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      "Finir l'inscription",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
