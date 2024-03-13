/*
Functions for loading assets (JavaScripts, CSS) asyncronously. If an asset is
tried to be loaded while it's loading the loader will be put in queue and when
the asset is loaded all in queue will be notified.
*/
store AssetLoader {
  state listeners : Map(String, Array(Function(Void, Void))) = Map.empty()
  state loading : Set(String) = Set.empty()
  state loaded : Set(String) = Set.empty()

  /* Loads the URL with the resolver. */
  fun load (url : String, resolver : Function(Promise(Void))) {
    let #(resolve, promise) =
      Promise.create()

    if Set.has(loaded, url) {
      await resolve(void)
    } else if Set.has(loading, url) {
      let nextListeners =
        listeners
        |> Map.getWithDefault(url, [])
        |> Array.push(resolve)

      next { listeners: Map.set(listeners, url, nextListeners) }
    } else {
      await next { loading: Set.add(loading, url) }
      await resolver()

      let currentListeners =
        Map.getWithDefault(listeners, url, [])

      for listener of currentListeners {
        listener(void)
      }

      resolve(void)

      next
        {
          listeners: Map.delete(listeners, url),
          loading: Set.delete(loading, url),
          loaded: Set.add(loaded, url)
        }
    }

    promise
  }

  /* Loads the stylesheet from the given URL. */
  fun loadStyle (url : String) : Promise(Void) {
    load(
      url: url,
      resolver:
        () {
          `
          new Promise((resolve) => {
            const link = document.createElement('link')

            link.rel = "stylesheet"
            link.onload = resolve
            link.href = #{url}

            document.head.appendChild(link)
          })
          `
        })
  }

  /* Loads the script from the given URL. */
  fun loadScript (url : String) : Promise(Void) {
    load(
      url: url,
      resolver:
        () {
          `
          new Promise((resolve) => {
            const script = document.createElement('script')

            script.type = "text/javascript";
            script.src = #{url}
            script.onload = () => {
              document.body.removeChild(script)
              resolve()
            }

            document.body.appendChild(script)
          })
          `
        })
  }

  /* Waits for all promises to load. */
  fun loadAll (
    method : Function(String, Promise(Void)),
    urls : Array(String)
  ) : Promise(Void) {
    `
    (async () => {
      for (let url of #{urls}) {
        await #{method}(url)
      }
    })()
    `
  }
}
