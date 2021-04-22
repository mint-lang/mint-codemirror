/* A component that integrates the CodeMirror editor. */
component CodeMirror {
  /* The JavaScript files of Codemirror to load, either locally or from a CDN. */
  property javascripts : Array(String) = [@asset(../assets/codemirror.min.js)]

  /* The CSS files of Codemirror to load, either locally or from a CDN. */
  property styles : Array(String) = [@asset(../assets/codemirror.min.css)]

  /* Handler for the change event. */
  property onChange : Function(String, Promise(Never, Void)) = Promise.never1

  /* The content to display until the editor is loaded. */
  property loadingContent : Html = <></>

  /* Whether or not show line numbers. */
  property lineNumbers : Bool = true

  /* Wether or not the content is editable. */
  property readOnly : Bool = false

  /* The number of spaces userd for indentation. */
  property tabSize : Number = 2

  /* When provided this value will be in the editor.s */
  property value : String = ""

  /* The theme of the editor. */
  property theme : String = ""

  /* The mode of the editor. */
  property mode : String = ""

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

          if (this.editor.getOption("theme") !== #{theme}) {
            this.editor.setOption("theme", #{theme})
          }
        }
      }
    })()
    `
  }

  /* Styles for the editor. */
  style editor {
    if (`this.editor`) {
      display: block;
    } else {
      display: none;
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
