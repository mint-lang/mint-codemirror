/* A component that integrates the CodeMirror editor. */
component CodeMirror {
  /* The JavaScript files of Codemirror to load, either locally or from a CDN. */
  property javaScripts : Array(String) = [
    "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0" \
    "/codemirror.min.js"
  ]

  /* The CSS files of Codemirror to load, either locally or from a CDN. */
  property styles : Array(String) = [
    "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0" \
    "/codemirror.min.css"
  ]

  /* The content to display until the editor is loaded. */
  property loadingContent : Html = Html.empty()

  /* Handler for the change event. */
  property onChange : Function(String, Void) = (\value : String => void)

  /* The value of the editor. */
  property value : String = ""

  /* The theme of the editor. */
  property theme : String = ""

  /* The mode of the editor. */
  property mode : String = ""

  /* Whether or not show line numbers. */
  property lineNumbers : Bool = true

  /* Initializes the editor for the given dom element. */
  fun initializeEditor (element : Dom.Element) : Void {
    do {
      javaScripts
      |> Array.map(AssetLoader.loadScript)
      |> AssetLoader.loadAll()

      styles
      |> Array.map(AssetLoader.loadStyle)
      |> AssetLoader.loadAll()

      `
      (() => {
        if (this.editor) { return }

        this.editor = CodeMirror.fromTextArea(element, {
          lineNumbers: this.lineNumbers,
          theme: this.theme,
          mode: this.mode,
        })

        this.editor.on('change', (value) => {
          this.onChange(this.editor.getValue())
        })

        this.forceUpdate()
      })()
      `
    }
  }

  /* After an update, update the underlying editor instance. */
  fun componentDidUpdate : Void {
    `
    (() => {
      if (this.editor) {
        if (this.props.value != null) {
          if (this.editor.getValue() !== this.props.value) {
            this.editor.setValue(this.props.value);
          }
        }
      }
    })()
    `
  }

  style editor {
    display: {display};
  }

  /*
  Returns the content for the `display` property,
  to hide the textarea until it's ready.
  */
  get display : String {
    if (`this.editor`) {
      ""
    } else {
      "none"
    }
  }

  /* Renders the component. */
  fun render : Array(Html) {
    [
      <textarea::editor ref={initializeEditor}/>,
      if (`this.editor`) {
        Html.empty()
      } else {
        loadingContent
      }
    ]
  }
}

record Main.State {
  value : String
}
component Main {
  state : Main.State {
    value = "function(){ \n  <div>{ this.text }</div>\n}"
  }

  fun onChange (value : String) : Void {
    next { state | value = value }
  }

  fun render : Html {
    <CodeMirror
      javaScripts=[
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.min.js",
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/mode/jsx/jsx.min.js"
      ]
      styles=[
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/theme/dracula.min.css",
      ]
      onChange={onChange}
      value={state.value}
      theme="dracula"
      mode="jsx"
      />
  }
}
