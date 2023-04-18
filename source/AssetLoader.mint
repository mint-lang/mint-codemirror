/* Functions for loading assets (JavaScripts, CSS) asyncronously. */
module AssetLoader {
  /* Loads the stylesheet from the given URL. */
  fun loadStyle (url : String) : Promise(Void) {
    `Assets.loadStyle(#{url})`
  }

  /* Loads the script from the given URL. */
  fun loadScript (url : String) : Promise(Void) {
    `Assets.loadScript(#{url})`
  }

  /* Waits for all promises to load. */
  fun loadAll (
    method : Function(String, Promise(Void)),
    urls : Array(String)
  ) : Promise(Void) {
    `Assets.loadAll(#{method}, #{urls})`
  }
}
