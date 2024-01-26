/* A component that integrates the CodeMirror editor. */
component CodeMirror {
  /* The JavaScript files of Codemirror to load, either locally or from a CDN. */
  property javascripts : Array(String) = [@asset(../assets/codemirror.min.js)]

  /* The CSS files of Codemirror to load, either locally or from a CDN. */
  property styles : Array(String) = [@asset(../assets/codemirror.min.css)]

  /* Handler for the change event. */
  property onChange : Function(String, Promise(Void)) = Promise.never1

  /* The content to display until the editor is loaded. */
  property loadingContent : Html = <></>

  /* Whether or not to show the line numbers. */
  property lineNumbers : Bool = true

  /* Whether or not to wrap the lines. */
  property lineWrapping : Bool = false

  /* Whether or not the content is editable. */
  property readOnly : Bool = false

  /* The number of spaces used for indentation. */
  property tabSize : Number = 2

  /* When provided this value will be in the editor. */
  property value : String = ""

  /* The theme of the editor. */
  property theme : String = ""

  /* The mode of the editor. */
  property mode : String = ""

  state this = `{}`

  /* Loads all assets when the components mounts. */
  fun componentDidMount : Promise(Void) {
    await AssetLoader.loadAll(AssetLoader.loadScript, javascripts)
    await AssetLoader.loadAll(AssetLoader.loadStyle, styles)
    await initializeEditor()
  }

  /* Initializes the editor for the given dom element. */
  fun initializeEditor : Void {
    `
    (() => {

      if (!#{element}._0) { return }
      if (#{this}.editor) { return }

      #{this}.editor = CodeMirror.fromTextArea(#{element}._0, {
        lineNumbers: #{lineNumbers},
        lineWrapping: #{lineWrapping},
        readOnly: #{readOnly},
        tabSize: #{tabSize},
        theme: #{theme},
        value: #{value},
        mode: #{mode},
      })

      #{this}.editor.on('change', (value) => {
        #{onChange(`#{this}.editor.getValue()`)}
      })

      #{this}.editor.setValue(#{value});
    })()
    `
  }

  /* After an update, update the underlying editor instance. */
  fun componentDidUpdate : Void {
    `
    (() => {
      if (#{this}.editor) {
        if (#{value} != null) {
          if (#{this}.editor.getValue() !== #{value}) {
            #{this}.editor.setValue(#{value});
          }

          if (#{this}.editor.getOption("readOnly") !== #{readOnly}) {
            #{this}.editor.setOption("readOnly", #{readOnly})
          }

          if (#{this}.editor.getOption("theme") !== #{theme}) {
            #{this}.editor.setOption("theme", #{theme})
          }
        }
      }
    })()
    `
  }

  /* Styles for the editor. */
  style editor {
    if `#{this}.editor` {
      display: block;
    } else {
      display: none;
    }
  }

  /* Renders the component. */
  fun render : Html {
    <>
      <textarea::editor as element/>

      if `#{this}.editor` {
        <></>
      } else {
        loadingContent
      }
    </>
  }
}
