package com.example.heathee

import android.Manifest
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.provider.MediaStore
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.mr.flutter.plugin.filepicker.FileUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException


class MainActivity : FlutterActivity() {
    private val permissionCode = 21441


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        val permissionCheck = ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE)
//
//        if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), permissionCode)
//        } else {
//            checkGallery()
//        }

        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "/gallery").setMethodCallHandler { call, result ->
            when (call.method) {
                // 3
                "getItemCount" -> result.success(getGalleryImageCount());
                // 1
                "getMiniThumbnail" -> {
                    // 2
                    val index = (call.arguments as? Int) ?: 0
                    // 3
                    dataForMiniThumbnail(index) { data, id, created, location, path ->
                        // 4
                        result.success(mapOf<String, Any>(
                                "data" to data,
                                "id" to id,
                                "created" to created,
                                "location" to location,
                                "path" to path
                        ))
                    }
                };
                "getThumbnail" -> {
                    // 2
                    val index = (call.arguments as? Int) ?: 0
                    result.success(imageUri(index))
                    // 3
                }
                "imgCompress" -> {
                    val image = call.argument<ByteArray>("imageBytes")!!
                    val quality = call.argument<Int>("quality") ?: 100
                    val name = call.argument<String>("name")
                    val maxDimensions = call.argument<Int>("maxDimensions")!!
                    val maxSize = call.argument<Int>("maxSize")!!

                    result.success(imgCompress(BitmapFactory.decodeByteArray(image, 0, image.size), quality, name, maxDimensions, maxSize))
                }
                else -> println("unhandled")
            }
        }
    }

//    private fun checkGallery() {
//        println("number of items ${getGalleryImageCount()}")
//        dataForMiniThumbnail(0) { data, id, created, location, path ->
//            println("first item $data $id $created $location")
//        }
//    }

    private val columns = arrayOf(
            MediaStore.Images.Media.DATA,
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.DATE_ADDED,
            MediaStore.Images.Media.LATITUDE,
            MediaStore.Images.Media.LONGITUDE)

//    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
//        if (requestCode == permissionCode
//                && grantResults.isNotEmpty()
//                && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//            checkGallery()
//        }
//    }

    private fun imgCompress(bmp: Bitmap, quality: Int, name: String?, maxDimensions: Int, maxSize: Int): ByteArray? {
        var result : ByteArray? = null

        println("ImageGallerySaverPlugin $quality")
        result = compressing(quality, bmp, maxDimensions, maxSize)
        bmp.recycle()
        println("Compressing done")
        return result

    }

    private fun compressing( quality: Int, bmp: Bitmap, maxDimensions: Int, maxSize: Int): ByteArray {
        val bos = ByteArrayOutputStream()
        val resizedBitmap: Bitmap
        var result : ByteArray
        if (bmp.width > maxDimensions || bmp.height > maxDimensions) {
            resizedBitmap = getResizedImg(bmp,
                    maxDimensions)
        } else {
            resizedBitmap = bmp
        }
        resizedBitmap.compress(Bitmap.CompressFormat.JPEG, 100, bos)



//        result = bos.toByteArray()

        println("현재 파일사이즈 : ${bos.toByteArray().size / 1024}")
        var temp : Int = quality
        while (bos.toByteArray().size / 1024 > 500) {
            bos.reset()

            println("현재 퀄리티 : ${temp.toString()}")

            resizedBitmap.compress(Bitmap.CompressFormat.JPEG, temp, bos)

            println("현재 파일사이즈 : ${bos.toByteArray().size / 1024}")
            temp -= 5
        }



        return bos.toByteArray()
    }


    private fun getbytearray(extension: String, resizedBitmap: Bitmap, quality: Int, bos: ByteArrayOutputStream): ByteArray {

        println("현재 퀄리티 : ${quality.toString()}")
        when (extension) {
            "jpg" -> {
                resizedBitmap.compress(Bitmap.CompressFormat.JPEG, quality, bos)
            }
            "jpeg" -> {
                resizedBitmap.compress(Bitmap.CompressFormat.JPEG, quality, bos)
            }
            "png" -> {
                resizedBitmap.compress(Bitmap.CompressFormat.PNG, quality, bos)
            }
        }
        return bos.toByteArray()
    }

    private fun getResizedImg(bitmap: Bitmap, maxSize: Int): Bitmap {
        var width: Int = bitmap.getWidth()
        var height: Int = bitmap.getHeight()
        println("리사이즈될 크기 in channel : $maxSize")
        val bitmapRatio = width.toFloat() / height.toFloat()
        if (bitmapRatio > 1) {
            width = maxSize
            height = (width / bitmapRatio).toInt()
        } else {
            height = maxSize
            width = (height * bitmapRatio).toInt()
        }

        return Bitmap.createScaledBitmap(bitmap, width, height, true)
    }

    private fun getGalleryImageCount(): Int {
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        // 1 Here, you open a cursor using the columns provided. The cursor is pointed at the media content in your external storage.
        val cursor = contentResolver.query(uri, columns, null, null, null);
        val count = cursor?.count ?: 0
        cursor.close()
        // 2 You return the total number of items in that cursor. You are also handling the case of the cursor being null. In that case, the count will be zero.
        return count
    }

    private fun imageUri(index: Int): String {
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val orderBy = MediaStore.Images.Media.DATE_TAKEN
        val cursor = contentResolver.query(uri, columns, null, null, null)
        cursor.move(index)
        val path = cursor.getString(0)
        cursor.close()
        return path;
    }

    private fun dataForMiniThumbnail(index: Int, completion: (ByteArray, String, Int, String, String)
    -> Unit) {
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val orderBy = MediaStore.Images.Media.DATE_TAKEN
        // 1 Here, you open a cursor again with the columns from earlier. You also request sorted items descending with the date taken.
        val cursor = contentResolver.query(uri, columns, null, null, null)

        cursor?.apply {
            // 2 This moves the cursor to that index.
            moveToPosition(index)

            // 3 Then, you get each column item’s column index and the image id.
            val pathIndex = getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            val idIndex = getColumnIndexOrThrow(MediaStore.Images.Media._ID)
            val createdIndex = getColumnIndexOrThrow(MediaStore.Images.Media.DATE_ADDED)
            val latitudeIndex = getColumnIndexOrThrow(MediaStore.Images.Media.LATITUDE)
            val longitudeIndex = getColumnIndexOrThrow(MediaStore.Images.Media.LONGITUDE)
            val id = getString(idIndex)
            // 4 This block of code gets a thumbnail of the image and converts the bitmap to a byte array.
            val bmp = MediaStore.Images.Thumbnails.getThumbnail(contentResolver, id.toLong(), MediaStore.Images.Thumbnails.MINI_KIND, null)
            val stream = ByteArrayOutputStream()
            bmp.compress(Bitmap.CompressFormat.JPEG, 70, stream)
            bmp.recycle()
            val data = stream.toByteArray()

            // 5 Here, you get the corresponding data for each column item. Depending on the data type of that column, use an appropriate method.
            val created = getInt(createdIndex)
            val latitude = getDouble(latitudeIndex)
            val longitude = getDouble(longitudeIndex)
            val path = getString(0);
            // 6 Finally, hand all the data that you got to a completion function.
            completion(data, id, created, "$latitude, $longitude", path)
        }
        cursor.close()
    }
}

