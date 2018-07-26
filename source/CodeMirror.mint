/* A component that integrates the CodeMirror editor. */
component CodeMirror {
  /* The JavaScript files of Codemirror to load, either locally or from a CDN. */
  property javascripts : Array(String) = [
    "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.min.js"
  ]

  /* The CSS files of Codemirror to load, either locally or from a CDN. */
  property styles : Array(String) = [
    "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0/codemirror.min.css"
  ]

  /* Handler for the change event. */
  property onChange : Function(String, Void) = ((value : String) : Void => { void })

  /* The content to display until the editor is loaded. */
  property loadingContent : Html = Html.empty()

  /* Whether or not show line numbers. */
  property lineNumbers : Bool = true

  /* When provided this value will be in the editor.s */
  property value : String = ""

  /* The theme of the editor. */
  property theme : String = ""

  /* The mode of the editor. */
  property mode : String = ""

  /* Loads all assets when the components mounts. */
  fun componentDidMount : Void {
    do {
      AssetLoader.loadAll(AssetLoader.loadScript, javascripts)
      AssetLoader.loadAll(AssetLoader.loadStyle, styles)
      initializeEditor()
    }
  }

  /* Saves the reference to the textarea. */
  fun saveReference (element : Dom.Element) : Void {
    `
    (() => {
      if (this.element) { return }
      this.element = element
    })()
    `
  }

  /* Initializes the editor for the given dom element. */
  fun initializeEditor () : Void {
    do {
      `
      (() => {
        if (!this.element) { return }
        if (this.editor) { return }

        this.editor = CodeMirror.fromTextArea(this.element, {
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
      <textarea::editor ref={saveReference}/>,
      if (`this.editor`) {
        Html.empty()
      } else {
        loadingContent
      }
    ]
  }
}
