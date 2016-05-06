# VCPhotoUtils
A photo utility library around Photos framework to observe for recent photos. 

# Idea and inspiration
* Facebook 

  ![](http://i.imgur.com/KotwyUX.jpg)
  
# Demo
  (wait for it to load)
  ![](http://i.imgur.com/zAxVb6r.gifv)
  
# How to use 
  
  * Create an object for `VCPhotoUtils` class
  * The `observeForRecentNewPhotos` block returns the changes in the camera roll
  * Make sure you use the  `startObservers` method to start observing for changes. This observes for app's active and inactive states. 
  * Use the `setSeenRecentPhotos` method to handle user's seen and unseen status of the recent photos. You'll not want to show the same photos again if the user has already seen them, similar to facebook's behaviour
  * The `observeForRecentNewPhotos` returns `PHFetchResults` so that you can use the Photos Library methods to display and cache the images
  * See the example project. 
  
  P.S: I've been a ObjC dev all this time, this is my first swift opensource project, i know i might not have used "swifty" syntax, so comments and suggestions welcome
  
# Licence
  MIT License
  
