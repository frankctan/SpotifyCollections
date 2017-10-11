
# SpotifyCollectionsView

![preview](https://i.imgur.com/lEkxCq2.gif)

**Featuring**
- infinite scrolling
- asynchronous image loading
- image loading is prioritized based on visible cells
- images are cached to minimize network usage
- no outside dependencies

**Installation**
- Obtain a client ID and client secret key [here](https://developer.spotify.com/web-api/authorization-guide/)
- Copy + paste the resulting authorization header in Secrets.swift (should start with "Basic ...")
- Run the thing!

**Outstanding**
- Image loading operations are added to a low priority queue by default. These ops are bumped to a high priority queue when their corresponding cells are visible, but are never downgraded back to low priority after their corresponding cells aren't visible anymore. 
- Image caching is achieved using a simple `[SpotifyID: Image]` dictionary. This is not good because all album images are saved in memory. Investigate other solutions such as `NSCache` or saving images to disk. 

 