/* A component that integrates the CodeMirror editor. */
component CodeMirror {
  /* The JavaScript files of Codemirror to load, either locally or from a CDN. */
  property javascripts : Array(String) =
    [
      "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0" \
      "/codemirror.min.js"
    ]

  /* The CSS files of Codemirror to load, either locally or from a CDN. */
  property styles : Array(String) =
    [
      "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.39.0" \
      "/codemirror.min.css"
    ]

  /* Handler for the change event. */
  property onChange : Function(String, Promise(Never, Void)) =
    ((value : String) : Promise(Never, Void) { next {  } })

  /* The content to display until the editor is loaded. */
  property loadingContent : Html = <></>

  /* Whether or not show line numbers. */
  property lineNumbers : Bool = true

  /* The number of spaces userd for indentation. */
  property tabSize : Number = 2

  /* When provided this value will be in the editor.s */
  property value : String = ""

  /* The theme of the editor. */
  property theme : String = ""

  /* The mode of the editor. */
  property mode : String = ""

  /* Wether or not the content is editable. */
  property readOnly : Bool = false

  /* Loads all assets when the components mounts. */
  fun componentDidMount : Promise(Never, Void) {
    sequence {
      AssetLoader.loadAll(AssetLoader.loadScript, javascripts)
      AssetLoader.loadAll(AssetLoader.loadStyle, styles)
      initializeEditor()
    }
  }

  /* Initializes the editor for the given dom element. */
  fun initializeEditor : Void {
    `
    (() => {

      if (!#{element}._0) { return }
      if (this.editor) { return }

      this.editor = CodeMirror.fromTextArea(#{element}._0, {
        lineNumbers: #{lineNumbers},
        readOnly: #{readOnly},
        tabSize: #{tabSize},
        theme: #{theme},
        mode: #{mode},
      })

      this.editor.on('change', (value) => {
        #{onChange(`this.editor.getValue()`)}
      })

      this.forceUpdate()
    })()
    `
  }

  /* After an update, update the underlying editor instance. */
  fun componentDidUpdate : Void {
    `
    (() => {
      if (this.editor) {
        if (#{value} != null) {
          if (this.editor.getValue() !== #{value}) {
            this.editor.setValue(#{value});
          }

          if (this.editor.getOption("readOnly") !== #{readOnly}) {
            this.editor.setOption("readOnly", #{readOnly})
          }
        }
      }
    })()
    `
  }

  style editor {
    display: #{display};
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
  fun render : Html {
    <>
      <textarea::editor as element/>

      if (`this.editor`) {
        <></>
      } else {
        loadingContent
      }
    </>
  }
}
