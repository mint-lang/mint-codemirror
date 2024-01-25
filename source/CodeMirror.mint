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

  const THIS = `{}`

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
      if (#{THIS}.editor) { return }

      #{THIS}.editor = CodeMirror.fromTextArea(#{element}._0, {
        lineNumbers: #{lineNumbers},
        lineWrapping: #{lineWrapping},
        readOnly: #{readOnly},
        tabSize: #{tabSize},
        theme: #{theme},
        mode: #{mode},
      })

      #{THIS}.editor.on('change', (value) => {
        if (#{THIS}.editor.getValue() !== #{value}) {
          #{onChange(`#{THIS}.editor.getValue()`)}
        }
      })

      #{THIS}.editor.setValue(#{value});
    })()
    `
  }

  /* After an update, update the underlying editor instance. */
  fun componentDidUpdate : Void {
    `
    (() => {
      if (#{THIS}.editor) {
        if (#{value} != null) {
          if (#{THIS}.editor.getValue() !== #{value}) {
            #{THIS}.editor.setValue(#{value});
          }

          if (#{THIS}.editor.getOption("readOnly") !== #{readOnly}) {
            #{THIS}.editor.setOption("readOnly", #{readOnly})
          }

          if (#{THIS}.editor.getOption("theme") !== #{theme}) {
            #{THIS}.editor.setOption("theme", #{theme})
          }
        }
      }
    })()
    `
  }

  /* Styles for the editor. */
  style editor {
    if `#{THIS}.editor` {
      display: block;
    } else {
      display: none;
    }
  }

  /* Renders the component. */
  fun render : Html {
    <>
      <textarea::editor as element/>

      if `#{THIS}.editor` {
        <></>
      } else {
        loadingContent
      }
    </>
  }
}
