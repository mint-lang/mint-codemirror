/* Functions for loading assets (JavaScripts, CSS) asyncronously. */
module AssetLoader {
  /* Loads the stylesheet from the given URL. */
  fun loadStyle (url : String) : Promise(Never, Void) {
    `Assets.loadStyle(url)`
  }

  /* Loads the script from the given URL. */
  fun loadScript (url : String) : Promise(Never, Void) {
    `Assets.loadScript(url)`
  }

  /* Waits for all promises to load. */
  fun loadAll (
    method : Function(String, Promise(Never, Void)),
    urls : Array(String)
  ) : Promise(Never, Void) {
    `Assets.loadAll(method, urls)`
  }
}
