const Assets = new (class Assets {
  constructor () {
    this.loading = new Set()
    this.loaded = new Set()
    this.listeners = {}
  }

  loadStyle (url) {
    return this.load(url, (resolve) => {
      const link = document.createElement('link')

      link.rel = "stylesheet"
      link.onload = resolve
      link.href = url

      document.head.appendChild(link)
    })
  }

  loadScript (url) {
    return this.load(url, (resolve) => {
      const script = document.createElement('script')

      script.type = "text/javascript";
      script.src = url
      script.onload = () => {
        document.body.removeChild(script)
        resolve()
      }

      document.body.appendChild(script)
    })
  }

  load (url, processor) {
    return new Promise((resolve) => {
      if (this.loaded.has(url)) {
        resolve()
      } else if (this.loading.has(url)) {
        this.listeners[url].push(resolve)
      } else {
        this.listeners[url] = [resolve]
        this.loading.add(url)
        processor(() => {
          this.onLoad(url)
        })
      }
    })
  }

  loadAll (method, urls) {
    return new Promise((resolve, reject) => {
      const items = urls.slice()

      const next = async () => {
        const url = items.shift()

        if (url) {
          await method(url)
          await next()
        } else {
          resolve()
        }
      }

      next()
    })
  }

  onLoad(url) {
    this.loading.delete(url)

    for (let listener of this.listeners[url] || []) {
      listener()
    }

    delete this.listeners[url]
    this.loaded.add(url)
  }
});
